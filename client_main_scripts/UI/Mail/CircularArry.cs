using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class CircularArry<T>
{

	public CircularArry()
	{
		m_linkList = new LinkedList<T>();
	}

	public CircularArry(int count):this()
	{
		m_count = count;
	}

	private int m_count = 2;
	public int Count
	{
		get
		{
			return m_count;
		}

		set
		{
			m_count = value;
		}
	}

	private readonly LinkedList<T> m_linkList;

	public LinkedListNode<T> First { get { return m_linkList.First; } }
	public LinkedListNode<T> Last { get { return m_linkList.Last; } }

	public void Add(T item)
	{

		if (m_linkList.Count >= m_count)
		{
			LinkedListNode<T> node = m_linkList.First;
			m_linkList.RemoveFirst();
			node.Value = item;
			m_linkList.AddLast(node);
		}
		else
		{

			m_linkList.AddLast(item);
		}

	}


	public T[] ToArray()
	{
		int count = m_linkList.Count;
		T[] array = new T[count];
		int i = 0;
		LinkedListNode<T> node = m_linkList.First;
		while (node != null)
		{
			array[i] = node.Value;
			i++;
			node = node.Next;
		}
		return array;
	}


	public void Clear()
	{
		m_linkList.Clear();
	}
}
