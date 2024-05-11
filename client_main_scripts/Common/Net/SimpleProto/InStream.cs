using System;
using System.Collections;
using System.Collections.Generic;

namespace SimpleProto
{
    public class InStream
    {
        public InStream(Buffer buffer)
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
        }

        public void Read(ref short val)
        {
            Skip(2);
            val = SimpleBitConverter.ToShort(m_buffer.buffer, m_offset - 2);
        }

        public void Read(ref ushort val)
        {
            Skip(2);
            val = (ushort)SimpleBitConverter.ToShort(m_buffer.buffer, m_offset - 2);
        }

        public void Read(ref int val)
        {
            Skip(4);
            val = SimpleBitConverter.ToInt(m_buffer.buffer, m_offset - 4);
        }

        public void Read(ref uint val)
        {
            Skip(4);
            val = (uint)SimpleBitConverter.ToInt(m_buffer.buffer, m_offset - 4);
        }

        public void Read(ref long val)
        {
            Skip(8);
            val = SimpleBitConverter.ToLong(m_buffer.buffer, m_offset - 8);
        }

        public void Read(ref ulong val)
        {
            Skip(8);
            val = (ulong)SimpleBitConverter.ToLong(m_buffer.buffer, m_offset - 8);
        }

        public void Read(ref byte val)
        {
            Skip(1);
            val = m_buffer.buffer[m_offset - 1];
        }

        public void Read(ref sbyte val)
        {
            Skip(1);
            val = (sbyte)m_buffer.buffer[m_offset - 1];
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
            val = System.Text.Encoding.UTF8.GetString(m_buffer.buffer, m_offset-length, length);
            byte eos = 0;
            this.Read(ref eos);
        }

        public void Read(ref byte[] buffer)
        {
            int length = 0;
            this.Read(ref length);
            buffer = new byte[length];
            System.Array.Copy(m_buffer.buffer, m_offset, buffer, 0, length);
            m_offset += length;
        }

        public void Read(ref Buffer buffer)
        {
            int length = 0;
            this.Read(ref length);
            buffer.ExpandTo(length);
            System.Array.Copy(m_buffer.buffer, m_offset, buffer.buffer, 0, length);
            buffer.SetLength(length);
            m_offset += length;
        }

        public void Skip(int size)
        {
            if (m_offset + size > m_buffer.length)
            {
                GameFramework.Log.Error("stream out of range {0}", size);
                return;
            }

            m_offset += size;
        }
        public int BytesLeft()
        {
            return m_buffer.length - m_offset;
        }

        public void Rewind()
        {
            m_offset = 0;
        }
        public Buffer GetBuffer() { return m_buffer; }
        public int Offset { get { return m_offset; } }
        private Buffer m_buffer;
        private int m_offset = 0;
    }
}
