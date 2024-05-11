using System;

namespace ProtoBufNet
{
    public class NetBuffer
    {
        public NetBuffer(int iniSize)
        {
            m_buffer = new byte[iniSize];
        }

        public void Resize(int size)
        {
            if (size <= this.capcity)
                return;

            int next = this.capcity;
            do
            {
                next *= 2;
            }
            while (next < size);

            byte[] new_buffer = new byte[next];
            m_buffer.CopyTo(new_buffer, 0);
            m_buffer = new_buffer;
        }

        public byte[] buffer
        {
            get
            {
                return m_buffer;
            }
            set
            {
                m_buffer = value;
            }
        }

        public int capcity
        {
            get
            {
                return m_buffer.Length;
            }
        }

        public int length
        {
            get
            {
                return m_length;
            }
            set
            {
                m_length = value;
            }
        }
        //public 

        private byte[] m_buffer;
        private int m_length;
    }


    internal class ArrayCache
    {

    }
}
