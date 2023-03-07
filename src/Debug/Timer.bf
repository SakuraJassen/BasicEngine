using System.Collections;
using System.Diagnostics;
using System;

namespace BasicEngine.Debug
{
	static class Timer
	{
		static private Dictionary<String, Stopwatch> mStopwatches = new Dictionary<String, Stopwatch>() ~ DeleteDictionaryAndValues!(_);

		static public Stopwatch this[String name] { get { return mStopwatches[name]; } }

		static public Stopwatch Add(String name, bool startTimerImmediately = false, bool takeOwnership = false)
		{
			Stopwatch sw = null;

			switch (takeOwnership)
			{
			case true:
				sw = new Stopwatch(startTimerImmediately);
				mStopwatches.Add(name, sw);
			case false:
				sw = new Stopwatch(startTimerImmediately);
				mStopwatches.Add(ToGlobalString!(name), sw);
			}

			return sw;
		}

		static public Stopwatch AddAndStart(String name, bool takeOwnership = false)
		{
			Stopwatch sw = null;
			if (mStopwatches.ContainsKey(name))
			{
				sw = mStopwatches[name];
				sw.Start();
				if (takeOwnership)
					SafeDelete!(name);
			}
			else
			{
				sw = Add(name, true, takeOwnership);
			}
			return sw;
		}

		static public Stopwatch Add()
		{
			var sw = new Stopwatch();
			mStopwatches.Add(ToGlobalString!(mStopwatches.Count + 1), sw);
			return sw;
		}

		static public Stopwatch Start(String name)
		{
			var sw = mStopwatches[name];
			sw.Start();
			return sw;
		}

		static public Stopwatch Stop(String name)
		{
			var sw = mStopwatches[name];
			sw.Stop();
			return sw;
		}

		static public Result<void> Remove(String name)
		{
			var res = mStopwatches.GetAndRemove(name);
			switch (res)
			{
			case .Err:
				return .Err((.)"Couldn't find Timer.");
			case .Ok(let sw):
				SafeDelete!(sw.value);
				SafeDelete!(sw.key);
				return .Ok((void)0);
			}
		}

		static public void Clear()
		{
			DeleteDictionaryAndKeysAndValues!(mStopwatches);
			mStopwatches = new Dictionary<String, Stopwatch>();
		}

		public static void PrintAllTimer()
		{
			for (var valuePairs in mStopwatches)
			{
				if (valuePairs.value.ElapsedMicroseconds == 0)
					continue;
				Logger.Log(StackStringFormat!("{} - {}", valuePairs.key, TimeSpan(valuePairs.value.ElapsedMicroseconds)));
			}
		}
	}

	static class Measurement
	{
		static public void LogTimeAvrg<TFunc>(delegate TFunc() funcPtr, int funcRepeats, int repeats)
		{
			int64 totalTime = 0;
			float lowest = float.MaxValue;
			float highest = float.MinValue;
			for (int i < repeats)
			{
				var time = Measurement.TimeFunc<TFunc>(funcPtr, funcRepeats).1;
				totalTime += time;
				if (time < lowest)
					lowest = time;

				if (time > highest)
					highest = time;
			}
			float avrg = totalTime;
			avrg /= repeats;
			Logger.Log(StackStringFormat!("Timed the function {} times ", funcRepeats * repeats));
			Logger.Log(StackStringFormat!("elapsed time: {}", TimeSpan(totalTime)));
			Logger.Log(StackStringFormat!("average ms:   {}", TimeSpan((int64)avrg)));
			Logger.Log(StackStringFormat!("highest time: {}", TimeSpan((int64)highest)));
			Logger.Log(StackStringFormat!("lowest  time: {}", TimeSpan((int64)lowest)));
		}

		static public void LogTime<TFunc>(delegate TFunc() funcPtr, int repeats = 1)
		{
			float ret = (float)TimeFunc<TFunc>(funcPtr, repeats).1 / 1000;
			Logger.Log(StackStringFormat!("{} ms (times {} repeated)", ret, repeats));
		}

		static public (TFunc, int64) TimeFunc<TFunc>(delegate TFunc() funcPtr, int repeats = 1)
		{
			var sw = scope Stopwatch();
			TFunc ret = default(TFunc);
			for (int i < repeats)
			{
				sw.Start();
				ret = funcPtr();
				sw.Stop();
			}
			return (ret, sw.ElapsedMicroseconds);
		}

		static public void LogTimeAvrg<TFunc, T>(delegate TFunc(T) funcPtr, T arg, int funcRepeats, int repeats)
		{
			int64 totalTime = 0;
			float lowest = float.MaxValue;
			float highest = float.MinValue;
			for (int i < repeats)
			{
				var time = Measurement.TimeFunc<TFunc, T>(funcPtr, arg, funcRepeats).1;
				totalTime += time;
				if (time < lowest)
					lowest = time;

				if (time > highest)
					highest = time;
			}
			float avrg = totalTime;
			avrg /= repeats;
			Logger.Log(StackStringFormat!("Timed the function {} times ", funcRepeats * repeats));
			Logger.Log(StackStringFormat!("elapsed time: {}", TimeSpan(totalTime)));
			Logger.Log(StackStringFormat!("average ms:   {}", TimeSpan((int64)avrg)));
			Logger.Log(StackStringFormat!("highest time: {}", TimeSpan((int64)highest)));
			Logger.Log(StackStringFormat!("lowest  time: {}", TimeSpan((int64)lowest)));
		}

		static public void LogTime<TFunc, T>(delegate TFunc(T) funcPtr, T arg, int repeats = 1)
		{
			float ret = (float)TimeFunc<TFunc, T>(funcPtr, arg, repeats).1 / 1000;
			Logger.Log(StackStringFormat!("{} ms (times {} repeated)", ret, repeats));
		}

		static public (TFunc, int64) TimeFunc<TFunc, T>(delegate TFunc(T) funcPtr, T arg, int repeats = 1)
		{
			var sw = scope Stopwatch();
			TFunc ret = default(TFunc);
			for (int i < repeats)
			{
				sw.Start();
				ret = funcPtr(arg);
				sw.Stop();
			}
			return (ret, sw.ElapsedMicroseconds);
		}

		static public int64 TimeFuncVoid(delegate void() funcPtr, int repeats = 1)
		{
			var sw = scope Stopwatch();
			for (int i < repeats)
			{
				sw.Start();
				funcPtr();
				sw.Stop();
			}
			return sw.ElapsedMicroseconds;
		}

		static public int64 TimeFuncVoid<T>(delegate void(T) funcPtr, T param, int repeats = 1)
		{
			var sw = scope Stopwatch();
			for (int i < repeats)
			{
				sw.Start();
				funcPtr(param);
				sw.Stop();
			}
			return sw.ElapsedMicroseconds;
		}
	}
}
