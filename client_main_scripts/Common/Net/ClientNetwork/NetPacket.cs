using System;
using System.Text;
using GameFramework;
using Sfs2X.Bitswarm;
using Sfs2X.Controllers;
using Sfs2X.Core;
using Sfs2X.Entities.Data;
using Sfs2X.Exceptions;
using Sfs2X.Protocol.Serialization;
using Sfs2X.Util;


namespace ProtoBufNet
{
    public class package_header
    {
        private int expectedLength = -1;
        private bool binary = true;
        private bool compressed;
        private bool encrypted;
        private bool blueBoxed;
        private bool bigSized;

        public int ExpectedLength
        {
            get { return this.expectedLength; }
            set { this.expectedLength = value; }
        }

        public bool Encrypted
        {
            get { return this.encrypted; }
            set { this.encrypted = value; }
        }

        public bool Compressed
        {
            get { return this.compressed; }
            set { this.compressed = value; }
        }

        public bool BlueBoxed
        {
            get { return this.blueBoxed; }
            set { this.blueBoxed = value; }
        }

        public bool Binary
        {
            get { return this.binary; }
            set { this.binary = value; }
        }

        public bool BigSized
        {
            get { return this.bigSized; }
            set { this.bigSized = value; }
        }

        public package_header(bool encrypted, bool compressed, bool blueBoxed, bool bigSized)
        {
            this.compressed = compressed;
            this.encrypted = encrypted;
            this.blueBoxed = blueBoxed;
            this.bigSized = bigSized;
        }

        public static package_header FromBinary(int headerByte)
        {
            return new package_header((headerByte & 64) > 0, (headerByte & 32) > 0, (headerByte & 16) > 0,
                (headerByte & 8) > 0);
        }

        public byte Encode()
        {
            byte num = 0;
            if (this.binary)
                num |= (byte) 128;
            if (this.Encrypted)
                num |= (byte) 64;
            if (this.Compressed)
                num |= (byte) 32;
            if (this.blueBoxed)
                num |= (byte) 16;
            if (this.bigSized)
                num |= (byte) 8;
            return num;
        }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("---------------------------------------------\n");
            stringBuilder.Append("Binary:  \t" + this.binary.ToString() + "\n");
            stringBuilder.Append("Compressed:\t" + this.compressed.ToString() + "\n");
            stringBuilder.Append("Encrypted:\t" + this.encrypted.ToString() + "\n");
            stringBuilder.Append("BlueBoxed:\t" + this.blueBoxed.ToString() + "\n");
            stringBuilder.Append("BigSized:\t" + this.bigSized.ToString() + "\n");
            stringBuilder.Append("---------------------------------------------\n");
            return stringBuilder.ToString();
        }
    }

    public class NetPacket
    {
        
        private const int compressionThreshold = 1024;
        private const int maxMessageSize = 1000000;
        
        /**
         * write
         */
        private package_header header;
        private ByteArray buffer;

        /**
         * read
         */
        private ByteArray _headerBuff;
        private ByteArray _bodyLengthBuff;
        public int bodyLengthHasRead { get; set; }

        private ByteArray _bodyBuff;
        public int bodyHasRead { get; set; }
        public ISFSObject info { get; private set; }

        public NetPacket(bool read = true)
        {
            if (read)
            {
                _headerBuff = new ByteArray(new byte[sizeof(byte)]);
            }

            bodyLengthHasRead = 0;
            bodyHasRead = 0;
        }


        public package_header Header
        {
            get { return this.header; }
        }

        public ByteArray Buffer
        {
            get { return this.buffer; }
            set { this.buffer = value; }
        }

        public bool encode()
        {
            return false;
        }

        public ByteArray headerBuff()
        {
            return _headerBuff;
        }

        public ByteArray bodyLengthBuff()
        {
            return _bodyLengthBuff;
        }

        public ByteArray bodyBuff()
        {
            return _bodyBuff;
        }

        public void onBeforeSend(IMessage msg)
        {
            ByteArray binData = msg.Content.ToBinary();
            bool compressed = binData.DataLength > compressionThreshold;
            if (binData.DataLength > maxMessageSize)
                throw new SFSCodecError("Message size is too big: " + (object) binData.DataLength + ", the server limit is: " + maxMessageSize);
            int num = SFSIOHandler.SHORT_BYTE_SIZE;
            if (binData.DataLength > (int) ushort.MaxValue)
                num = SFSIOHandler.INT_BYTE_SIZE;
            
            header = new package_header(false, compressed, false, num == SFSIOHandler.INT_BYTE_SIZE);
           
            buffer = new ByteArray();
            if (header.Compressed)
                binData.Compress();
           
            buffer.WriteByte(header.Encode());
            if (header.BigSized)
                buffer.WriteInt(binData.DataLength);
            else
                buffer.WriteUShort(Convert.ToUInt16(binData.DataLength));
            buffer.WriteBytes(binData.GetBytes());
        }


        public void parseHeader()
        {
            byte num = _headerBuff.ReadByte();
            if (~((int) num & 128) > 0)
                throw new SFSError("Unexpected header byte: " + (object) num + "\n" +
                                   DefaultObjectDumpFormatter.HexDump(_headerBuff));
            header = package_header.FromBinary((int) num);
            if (header.BigSized)
            {
                _bodyLengthBuff = new ByteArray(new byte[sizeof(int)]);
            }
            else
            {
                _bodyLengthBuff = new ByteArray(new byte[sizeof(ushort)]);
            }
        }

        public void parseBodyLength()
        {
            int pos = SFSIOHandler.SHORT_BYTE_SIZE;
            int num = 0;
            if (this.header.BigSized)
            {
                num = _bodyLengthBuff.ReadInt();
            }
            else
            {
                num = (int) _bodyLengthBuff.ReadUShort();
            }

            header.ExpectedLength = num;
            _bodyBuff = new ByteArray(new byte[num]);
        }
        
        public void onPackageReceiveFinish()
        {
            try
            {
                var time = DateTime.Now.Millisecond;
                if (header.Compressed)
                {
                    _bodyBuff.Uncompress();
                }
                info = SFSObject.NewFromBinaryData(_bodyBuff);
                Log.Debug("byte->sfs {0} raw length {1} parse use {2} after length {3}",info.GetSFSObject(MessageDispather.PARAM_ID).GetUtfString(ExtensionController.KEY_CMD), header.ExpectedLength, DateTime.Now.Millisecond - time, _bodyBuff.DataLength);
            }
            catch (Exception ex)
            {
                Log.Error("parse mesg error {0}", ex.StackTrace);
            }
        }
    }
}