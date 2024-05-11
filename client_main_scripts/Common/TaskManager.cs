using UnityEngine;
using System.Collections;
using UnityGameFramework.Runtime;

public class Task
{

	public bool Running {
		get {
			return task.Running;
		}
	}
	

	public bool Paused {
		get {
			return task.Paused;
		}
	}
	

	public delegate void FinishedHandler(bool manual);

	public event FinishedHandler Finished;


	public Task(IEnumerator c, bool autoStart = true)
	{
		task = TaskManager.CreateTask(c);
		task.Finished += TaskFinished;
		if(autoStart)
			Start();
	}
	
	/// Begins execution of the coroutine
	public void Start()
	{
		task.Start();
	}

	/// Discontinues execution of the coroutine at its next yield.
	public void Stop()
	{
		task.Stop();
	}
	
	public void Pause()
	{
		task.Pause();
	}
	
	public void Unpause()
	{
		task.Unpause();
	}
	
	void TaskFinished(bool manual)
	{
		FinishedHandler handler = Finished;
		if(handler != null)
			handler(manual);
	}
	
	TaskManager.TaskState task;
}

class TaskManager : MonoBehaviour
{
	public class TaskState
	{
		public bool Running {
			get {
				return running;
			}
		}

		public bool Paused  {
			get {
				return paused;
			}
		}

		public delegate void FinishedHandler(bool manual);
		public event FinishedHandler Finished;

		IEnumerator coroutine;
		bool running;
		bool paused;
		bool stopped;
		
		public TaskState(IEnumerator c)
		{
			coroutine = c;
		}
		
		public void Pause()
		{
			paused = true;
		}
		
		public void Unpause()
		{
			paused = false;
		}
		
		public void Start()
		{
			running = true;
			singleton.StartCoroutine(CallWrapper());
		}
		
		public void Stop()
		{
			stopped = true;
			running = false;
		}
		
		IEnumerator CallWrapper()
		{
			yield return null;
			IEnumerator e = coroutine;
			while(running) {
				if(paused)
					yield return null;
				else {
					if(e != null && e.MoveNext()) {
						yield return e.Current;
					}
					else {
						running = false;
					}
				}
			}
			
			FinishedHandler handler = Finished;
			if(handler != null)
				handler(stopped);
		}
	}

	static TaskManager singleton;

	public static TaskState CreateTask(IEnumerator coroutine)
	{
		if(singleton == null) {
			GameObject go = new GameObject("TaskManager");
			singleton = go.AddComponent<TaskManager>();
			if (GameEntry.GameBase != null)
				go.transform.SetParent(GameEntry.GameBase.transform);
		}
		return new TaskState(coroutine);
	}
}
