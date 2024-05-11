using System;
using System.Collections.Generic;

namespace SimpleProto
{
    public class OutStream
    {
        public OutStream(Buffer buffer)
        {
            m_buffer = buffer;
        }
        public Buffer GetBuffer() { return m_buffer; }
        public int Offset { get { return m_offset; } }
        public void Seek(int offset) { m_offset = offset; }
        public void Write(bool val)
        {
            this.m_buffer.ExpandTo(m_offset + 1);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 1;
        }

        public void Write(double val)
        {
            this.m_buffer.ExpandTo(m_offset + 8);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 8;
        }

        public void Write(short val)
        {
            this.m_buffer.ExpandTo(m_offset + 2);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 2;
        }

        public void Write(ushort val)
        {
            this.m_buffer.ExpandTo(m_offset + 2);
            SimpleBitConverter.GetBytes((short)val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 2;
        }

        public void Write(int val)
        {
            this.m_buffer.ExpandTo(m_offset + 4);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 4;
        }

        public void Write(uint val)
        {
            this.m_buffer.ExpandTo(m_offset + 4);
            SimpleBitConverter.GetBytes((int)val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 4;
        }

        public void Write(long val)
        {
            this.m_buffer.ExpandTo(m_offset + 8);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 8;
        }

        public void Write(ulong val)
        {
            this.m_buffer.ExpandTo(m_offset + 8);
            SimpleBitConverter.GetBytes((long)val, m_buffer.buffer, m_offset);
            //byte[] array = BitConverter.GetBytes(val);
            //array.CopyTo(m_buffer.buffer, m_offset);
            m_offset += 8;
        }

        public void Write(byte val)
        {
            this.m_buffer.ExpandTo(m_offset + 1);
            m_buffer.buffer[m_offset] = val;
            m_offset += 1;
        }

        public void Write(sbyte val)
        {
            Write((byte)val);
        }

        public void Write(float val)
        {
            this.m_buffer.ExpandTo(m_offset + 4);
            //byte[] array = BitConverter.GetBytes(val);

            //array.CopyTo(m_buffer.buffer, m_offset);
            SimpleBitConverter.GetBytes(val, m_buffer.buffer, m_offset);
            m_offset += 4;
        }

        public void Write(string val)
        {
            //take care the encoding
            byte[] strval = System.Text.Encoding.UTF8.GetBytes(val);
            this.Write(strval.Length);
            this.m_buffer.ExpandTo(m_offset + strval.Length);

            strval.CopyTo(m_buffer.buffer, m_offset);
            m_offset += strval.Length;

            byte eos = 0;
            this.Write(eos);
        }

        public void Write(byte[] bytearray)
        {
            int length = bytearray.Length;

            this.Write(length);
            this.m_buffer.ExpandTo(m_offset + length);
            System.Array.Copy(bytearray, 0, m_buffer.buffer, m_offset, length);
            m_offset += length;
        }

        public void Write(Buffer buffer)
        {
            int length = buffer.length;

            this.Write(length);
            this.m_buffer.ExpandTo(m_offset + length);
            System.Array.Copy(buffer.buffer, 0, m_buffer.buffer, m_offset, length);
            m_offset += length;
        }

        private Buffer m_buffer;
        private int m_offset = 0;
    }
}
