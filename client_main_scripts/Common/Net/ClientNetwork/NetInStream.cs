using System;
using System.Collections;
using System.Collections.Generic;
using SimpleProto;

namespace ProtoBufNet
{
    public class NetInStream
    {
        public NetInStream(NetBuffer buffer)
        {
            m_buffer = buffer;
        }

        public void Read(ref bool val)
        {
            Skip(1);
            val = SimpleBitConverter.ToBool(m_buffer.buffer, m_offset - 1);
            //val = BitConverter.ToBoolean(m_buffer.buffer, m_offset - 1);
        }

        public void Read(ref float val)
        {
            Skip(4);
            val = SimpleBitConverter.ToFloat(m_buffer.buffer, m_offset - 4);
            //val = BitConverter.ToSingle(m_buffer.buffer, m_offset - 4);
        }

        public void Read(ref short val)
        {
            Skip(2);
            val = SimpleBitConverter.ToShort(m_buffer.buffer, m_offset - 2);
            //val = BitConverter.ToInt16(m_buffer.buffer, m_offset - 2);
        }

        public void Read(ref int val)
        {
            Skip(4);
            val = SimpleBitConverter.ToInt(m_buffer.buffer, m_offset - 4);
            //val = BitConverter.ToInt32(m_buffer.buffer, m_offset - 4);
        }

        public void Read(ref long val)
        {
            Skip(8);
            val = SimpleBitConverter.ToLong(m_buffer.buffer, m_offset - 8);
        }

        public void Read(ref byte val)
        {
            Skip(1);
            val = m_buffer.buffer[m_offset - 1];
        }

        public void Read(ref double val)
        {
            Skip(8);
            val = SimpleBitConverter.ToDouble(m_buffer.buffer, m_offset - 8);
        }

        public void Read(ref string val)
        {
            int length = 0;
            this.Read(ref length);
            Skip(length);
            val = System.Text.Encoding.Default.GetString(m_buffer.buffer, m_offset-length, length);
            byte eos = 0;
            this.Read(ref eos);
        }

        public void Read(ref NetBuffer buffer)
        {
            int length = 0;
            this.Read(ref length);
            buffer.Resize(length);
            System.Array.Copy(m_buffer.buffer, m_offset, buffer.buffer, 0, length);
            m_offset += length;
            buffer.length = length;
        }

        private void Skip(int size)
        {
            if (m_offset + size > m_buffer.length)
            {
                throw new NetStreamException("stream out of rang", size);
            }

            m_offset += size;
        }
 
        private NetBuffer m_buffer;
        private int m_offset = 0;
    }
}
