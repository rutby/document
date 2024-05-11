using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 从一个对象中取一个属性值
/// </summary>
/// <typeparam name="T">代表一个对象类型Person</typeparam>
/// <typeparam name="TKey">代表对象的一个属性 如Age</typeparam>
/// <param name="t">代表一个对象 具体的人</param>
/// <returns>属性的值 age的20</returns>
public delegate TKey SelectHandler<T , TKey>( T t );//Person>age
/// <summary>
/// 表示查找条件
/// </summary>
/// <typeparam name="T">数据类型 Person</typeparam>
/// <param name="t">对象 张三</param>
/// <returns>真，假</returns>
public delegate bool FindHandler<T>( T t );
/// <summary>
/// 工具类
/// </summary>
static public class ArrayHelper {

    /// <summary>
    /// 对任何类型的集合，按照任何一个属性的值去 排序
    /// （选择的属性要具备可比性=实现比较接口）
    ///  排序：升序（小 到大）
    ///适用于任何类型的集合对象
    ///适用于对象的任意属性（属性具有可比性）
    /// </summary>
    /// <typeparam name="T">任何数据类型 person，student</typeparam>
    /// <typeparam name="TKey">类的任何属性 ID，age</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    public static void OrderBy<T , TKey>( T[] arr ,
        SelectHandler<T , TKey> handler )
        where TKey : IComparable , IComparable<TKey> {
        for ( int i = 0 ; i < arr.Length - 1 ; i++ ) {
            for ( int j = i + 1 ; j < arr.Length ; j++ ) {
                if ( handler ( arr[ i ] ).CompareTo ( handler ( arr[ j ] ) ) > 0 ) {
                    var temp = arr[ i ];
                    arr[ i ] = arr[ j ];
                    arr[ j ] = temp;
                }
            }
        }
    }
    /// <summary>
    /// 2 降序排序（大到小）
    /// </summary>
    /// <typeparam name="T">任何数据类型</typeparam>
    /// <typeparam name="TKey">类的任何属性</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    public static void OrderByDescending<T , TKey>( T[] arr ,
      SelectHandler<T , TKey> handler )
      where TKey : IComparable , IComparable<TKey> {
        for ( int i = 0 ; i < arr.Length - 1 ; i++ ) {
            for ( int j = i + 1 ; j < arr.Length ; j++ ) {
                if ( handler ( arr[ i ] ).CompareTo ( handler ( arr[ j ] ) ) < 0 ) {
                    var temp = arr[ i ];
                    arr[ i ] = arr[ j ];
                    arr[ j ] = temp;
                }
            }
        }
    }
    /// <summary>
    ///3  找（某个属性值）最小的对象
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    /// <returns>（某个属性值）最小的对象</returns>
    public static T Min<T , TKey>( T[] arr ,
SelectHandler<T , TKey> handler )
where TKey : IComparable , IComparable<TKey> {
        T temp = default ( T );
        temp = arr[ 0 ];
        for ( int i = 1 ; i < arr.Length ; i++ ) {
            if ( handler ( temp ).CompareTo ( handler ( arr[ i ] ) ) > 0 ) {
                temp = arr[ i ];
            }
        }
        return temp;
    }

    /// <summary>
    ///4  找（某个属性值）最大的对象
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    /// <returns>（某个属性值）最小的对象</returns>
    public static T Max<T , TKey>( T[] arr , SelectHandler<T , TKey> handler ) where TKey : IComparable , IComparable<TKey> {
        T temp = default ( T );
        temp = arr[ 0 ];
        for ( int i = 1 ; i < arr.Length ; i++ ) {
            if ( arr[ i ] == null ) {
                continue;
            }

            if ( handler ( temp ).CompareTo ( handler ( arr[ i ] ) ) < 0 ) {
                temp = arr[ i ];
            }
        }
        return temp;
    }

    //5 从对象集合中，选取每个对象的某个属性的值，组成一个新的数组
    //所有的人 每个人的年龄 》年龄的数组
    public static TKey[] Select<T , TKey>( T[] arr ,
SelectHandler<T , TKey> handler ) {
        TKey[] temp = new TKey[ arr.Length ];

        for ( int i = 0 ; i < arr.Length ; i++ ) {
            temp[ i ] = handler ( arr[ i ] );
        }
        return temp;
    }

    //按照条件查找一个Find，
    /// <summary>
    /// 6 按照某个条件查找，返回符合条件的一个对象或null
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">查找的条件 bool =》</param>
    /// <returns>返回符合条件的一个对象或null</returns>
    public static T Find<T>( T[] arr , FindHandler<T> handler ) {
        T t = default ( T );
        for ( int i = 0 ; i < arr.Length ; i++ ) {
            if ( handler ( arr[ i ] ) ) {
                t = arr[ i ];
                return t;
            }
        }
        return t;
    }

    /// <summary>
    /// 7 按照条件查找，返回满足条件的所有的对象FindAll
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="arr"></param>
    /// <param name="handler">代表查找条件</param>
    /// <returns></returns>
    public static T[] FindAll<T>( T[] arr , FindHandler<T> handler ) {
        List<T> list = new List<T> ( );
        for ( int i = 0 ; i < arr.Length ; i++ ) {
            if ( handler ( arr[ i ] ) ) {
                var t = arr[ i ];
                list.Add ( t );
            }
        }
        return list.ToArray ( );
    }

    /// <summary>
    /// 打乱当前数组
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="arr">一维数组</param>
    /// <returns></returns>
    public static T[] Disrupted<T>( T[] arr )
    {
        System.Random rand = new System.Random( ListHelper.GetRandomSeed() );
        for ( int i = 0; i < arr.Length; i++ )
        {
            int k;
            T t;
            k = rand.Next( 0, arr.Length );
            if ( k != i )
            {
                t = arr[i];
                arr[i] = arr[k];
                arr[k] = t;
            }
        }
        return arr;
    }
}

static public class ListHelper {
    /// <summary>
    /// 升序排序（从小到大）
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <typeparam name="TKey"></typeparam>
    /// <param name="list"></param>
    /// <param name="handler"></param>
    public static void OrderBy<T , TKey>( List<T> list ,
    SelectHandler<T , TKey> handler )
    where TKey : IComparable , IComparable<TKey> {
        if ( list == null ) {
            return;
        }
        for ( int i = 0 ; i < list.Count - 1 ; i++ ) {
            for ( int j = i + 1 ; j < list.Count ; j++ ) {
                if ( handler ( list[ i ] ).CompareTo ( handler ( list[ j ] ) ) > 0 ) {
                    var temp = list[ i ];
                    list[ i ] = list[ j ];
                    list[ j ] = temp;
                }
            }
        }
    }

    /// <summary>
    ///  降序排序（大到小）
    /// </summary>
    /// <typeparam name="T">任何数据类型</typeparam>
    /// <typeparam name="TKey">类的任何属性</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    public static void OrderByDescending<T , TKey>( List<T> list ,
      SelectHandler<T , TKey> handler )
      where TKey : IComparable , IComparable<TKey> {
        if ( list == null ) {
            return;
        }
        for ( int i = 0 ; i < list.Count - 1 ; i++ ) {
            for ( int j = i + 1 ; j < list.Count ; j++ ) {
                if ( handler ( list[ i ] ).CompareTo ( handler ( list[ j ] ) ) < 0 ) {
                    var temp = list[ i ];
                    list[ i ] = list[ j ];
                    list[ j ] = temp;
                }
            }
        }
    }

    /// <summary>
    /// 随机排序
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="ListT"></param>
    /// <returns></returns>
    public static  List<T> RandomSortList<T>(List<T> ListT)
    {
        System.Random random = new System.Random();
        List<T> newList = new List<T>();
        foreach (T item in ListT)
        {
            newList.Insert(random.Next(newList.Count + 1), item);
        }
        Debug.Log(newList.Count);
        return newList;
    }
    
    /// <summary>
    /// 找（某个属性值）最小的对象
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    /// <returns>（某个属性值）最小的对象</returns>
    public static T Min<T , TKey>( List<T> list ,SelectHandler<T , TKey> handler )where TKey : IComparable , IComparable<TKey> {
        T temp = default ( T );
        temp = list[ 0 ];
        for ( int i = 1 ; i < list.Count ; i++ ) {
            if ( list[ i ] == null ) {
                continue;
            }
            if ( handler ( temp ).CompareTo ( handler ( list[ i ] ) ) > 0 ) {
                temp = list[ i ];
            }
        }
        return temp;
    }

    /// <summary>
    ///4  找（某个属性值）最大的对象
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <typeparam name="TKey">数据类型的某个属性</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">委托对象 从一个对象中取一个属性值</param>
    /// <returns>（某个属性值）最小的对象</returns>
    public static T Max<T , TKey>( List<T> list , SelectHandler<T , TKey> handler ) where TKey : IComparable , IComparable<TKey> {
        T temp = default ( T );
        temp = list[ 0 ];
        for ( int i = 1 ; i < list.Count ; i++ ) {
            if ( list[ i ] == null ) {
                continue;
            }

            if ( handler ( temp ).CompareTo ( handler ( list[ i ] ) ) < 0 ) {
                temp = list[ i ];
            }
        }
        return temp;
    }

    //按照条件查找一个Find，
    /// <summary>
    /// 6 按照某个条件查找，返回符合条件的一个对象或null
    /// </summary>
    /// <typeparam name="T">数据类型</typeparam>
    /// <param name="arr">对象集合</param>
    /// <param name="handler">查找的条件 bool =》</param>
    /// <returns>返回符合条件的一个对象或null</returns>
    public static T Find<T>( List<T> list , FindHandler<T> handler ) {
        T t = default ( T );
        for ( int i = 0 ; i < list.Count ; i++ ) {
            if ( list[ i ] != null ) 
                continue;

            if ( handler ( list[ i ] ) ) {
                t = list[ i ];
                return t;
            }
        }
        return t;
    }

    /// <summary>
    /// 7 按照条件查找，返回满足条件的所有的对象FindAll
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="arr"></param>
    /// <param name="handler">代表查找条件</param>
    /// <returns></returns>
    public static List<T> FindAll<T>( List<T> list , FindHandler<T> handler ) {
        List<T> temp = new List<T> ( );
        for ( int i = 0 ; i < list.Count ; i++ ) {
            if ( list[ i ] != null )
                continue;

            if ( handler ( list[ i ] ) ) {
                var t = list[ i ];
                list.Add ( t );
            }
        }
        return temp;
    }

    /// <summary>
    /// 把list转成Dictionary，根据某个属性转成字典key-list<value>
    /// </summary>
    /// <typeparam name="TKey">字典的key</typeparam>
    /// <typeparam name="T">list中的值</typeparam>
    /// <param name="list">要转换的list</param>
    /// <param name="handler">p=>p.value</param>
    /// <returns></returns>
    public static Dictionary<TKey , List<T>> ToDictionary<TKey , T>( List<T> list , SelectHandler<T , TKey> handler ) {
        Dictionary<TKey , List<T>> temp = new Dictionary<TKey , List<T>> ( );
        for ( int i = 0 ; i < list.Count ; i++ ) {
            if ( temp.ContainsKey ( handler ( list[ i ] ) ) ) {
                temp[ handler ( list[ i ] ) ].Add ( list[ i ] );
            } else {
                List<T> valueList = new List<T> ( );
                valueList.Add ( list[ i ] );
                temp[ handler ( list[ i ] ) ] = valueList;
            }
        }
        return temp;
    }

    /// <summary>
    /// 根据权重值打乱数组，并返回指定count的数组
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="list"></param>
    /// <param name="count"></param>
    /// <returns></returns>
    public static List<T> GetRandomList<T>( List<T> list, int count = 1) where T : iRandomObject
    {
        if (list == null || list.Count <= count || count <= 0)
        {
            return list;
        }

        //计算权重总和
        int totalWeights = 0;
        for (int i = 0; i < list.Count; i++)
        {
            totalWeights += list[i].Weight + 1;  //权重+1，防止为0情况。
        }

        //随机赋值权重
        System.Random ran = new System.Random(GetRandomSeed()); 
        List<KeyValuePair<int, int>> wlist = new List<KeyValuePair<int, int>>();    //第一个int为list下标索引、第一个int为权重排序值
        for (int i = 0; i < list.Count; i++)
        {
            int w = (list[i].Weight + 1) + ran.Next(0, totalWeights);   // （权重+1） + 从0到（总权重-1）的随机数
            wlist.Add(new KeyValuePair<int, int>(i, w));
        }

        //排序
        wlist.Sort(
          delegate(KeyValuePair<int, int> kvp1, KeyValuePair<int, int> kvp2)
          {
              return kvp2.Value - kvp1.Value;
          });

        //根据实际情况取排在最前面的几个
        List<T> newList = new List<T>();
        for (int i = 0; i < count; i++)
        {
            T entiy = list[wlist[i].Key];
            newList.Add(entiy);
        }

        //随机法则
        return newList;
    }


    /// <summary>
    /// 随机种子值
    /// </summary>
    /// <returns></returns>
    public static int GetRandomSeed()
    {
        byte[] bytes = new byte[4];
        System.Security.Cryptography.RNGCryptoServiceProvider rng = new System.Security.Cryptography.RNGCryptoServiceProvider();
        rng.GetBytes(bytes);
        return BitConverter.ToInt32(bytes, 0);
    }

    public static T GetRandomItem<T>(List<T> list)
    {
        if (list == null || list.Count == 0)
            return default(T);
        int index = UnityEngine.Random.Range(0, list.Count);
        return list[index];
    }
}




    /// <summary>
    /// 权重对象
    /// </summary>
    public interface iRandomObject
    {
        /// <summary>
        /// 权重
        /// </summary>
        int Weight { set; get; }
    }
