using System;
using System.Collections;
using System.Collections.Generic;

namespace SimpleProto
{
    public class SimpleBitConverter
    {
        public static void GetBytes(bool value, byte[] dst, int startIndex)
        {
            dst[startIndex] = (byte)(value ? 1 : 0);
        }

        public static void GetBytes(short value, byte[] dst, int startIndex)
        {
            dst[startIndex] = (byte)(value & 0xFF);
            dst[startIndex + 1] = (byte)((value >> 8) & 0xFF);
        }

        public static void GetBytes(int value, byte[] dst, int startIndex)
        {
            dst[startIndex] = (byte)(value & 0xFF);
            dst[startIndex + 1] = (byte)((value >> 8) & 0xFF);
            dst[startIndex + 2] = (byte)((value >> 16) & 0xFF);
            dst[startIndex + 3] = (byte)((value >> 24) & 0xFF);
        }

        public static void GetBytes(long value, byte[] dst, int startIndex)
        {
            dst[startIndex] = (byte)(value & 0xFF);
            dst[startIndex + 1] = (byte)((value >> 8) & 0xFF);
            dst[startIndex + 2] = (byte)((value >> 16) & 0xFF);
            dst[startIndex + 3] = (byte)((value >> 24) & 0xFF);
            dst[startIndex + 4] = (byte)((value >> 32) & 0xFF);
            dst[startIndex + 5] = (byte)((value >> 40) & 0xFF);
            dst[startIndex + 6] = (byte)((value >> 48) & 0xFF);
            dst[startIndex + 7] = (byte)((value >> 56) & 0xFF);
        }

        public static void GetBytes(float value, byte[] dst, int startIndex)
        {
            byte[] raw = BitConverter.GetBytes(value);
            byte[] tmp = ReverseOrder(raw, 0, raw.Length);
            System.Buffer.BlockCopy(tmp, 0, dst, startIndex, tmp.Length);
        }

        public static void GetBytes(double value, byte[] dst, int startIndex)
        {
            byte[] raw = BitConverter.GetBytes(value);
            byte[] tmp = ReverseOrder(raw, 0, raw.Length);
            System.Buffer.BlockCopy(tmp, 0, dst, startIndex, tmp.Length);
        }

        public static bool ToBool(byte[] value, int startIndex)
        {
            return value[startIndex] != 0;
        }

        public static short ToShort(byte[] value, int startIndex)
        {
            return (short)((value[0 + startIndex] & 0xFF) | ((value[startIndex + 1] << 8)));
        }

        public static int ToInt(byte[] value, int startIndex)
        {
            return (int)((value[0 + startIndex] & 0xFF) | ((value[startIndex + 1] << 8))
                         | ((value[startIndex + 2] << 16)) | ((value[startIndex + 3] << 24)));
        }

        public static long ToLong(byte[] value, int startIndex)
        {
            int n1 = (int)((value[0 + startIndex] & 0xFF) | ((value[startIndex + 1] << 8))
                         | ((value[startIndex + 2] << 16)) | ((value[startIndex + 3] << 24)));
            int n2 = (int)((value[4 + startIndex] & 0xFF) | ((value[startIndex + 5] << 8))
                         | ((value[startIndex + 6] << 16)) | ((value[startIndex + 7] << 24)));
            return (long)(n1 | ((long)n2) << 32);
        }

        public static float ToFloat(byte[] value, int startIndex)
        {
            return BitConverter.ToSingle(ReverseOrder(value, startIndex, 4), startIndex);
        }

        public static double ToDouble(byte[] value, int startIndex)
        {
            return BitConverter.ToDouble(ReverseOrder(value, startIndex, 8), startIndex);
        }


        private static byte[] ReverseOrder(byte[] buff, int startIndex, int length)
        {
            bool flag = BitConverter.IsLittleEndian;
            byte[] result;
            if (flag)
            {
                result = buff;
            }
            else
            {
                int num = length;
                bool flag2 = num < 2;
                if (flag2)
                {
                    result = buff;
                }
                else
                {
                    int num2 = num / 2;
                    for (int i = 0; i < num2; i++)
                    {
                        byte b = buff[i + startIndex];
                        int num3 = num - i - 1 + startIndex;
                        buff[i + startIndex] = buff[num3];
                        buff[num3] = b;
                    }
                    result = buff;
                }
            }
            return result;
        }
    }
}