using System;
namespace BasicEngine.Debug
{
	static class Logger
	{
		public static LogType mLoggerType = .Both;
		public enum LogType
		{
			Console = 0b01,
			File = 0b10,
			Both = Console | File
		}

		public static LogLevel mDisplayLevel = .Debug;
		public enum LogLevel
		{
			Error = 0,
			Warn = 1,
			Info = 2,
			Debug = 3,
		}

		public static void LogMeta(System.String fileName = System.Compiler.CallerFileName, int lineNum = System.Compiler.CallerLineNum, params Object[] args)
		{
			System.Diagnostics.Debug.Write("[{}] [{:000}:{}]", System.DateTime.Now.TimeOfDay, fileName, lineNum);

			for (var i < args.Count)
			{
				System.Diagnostics.Debug.Write("{}", args[i]);
				if (i < args.Count - 1)
					System.Diagnostics.Debug.Write(", ");
			}
			System.Diagnostics.Debug.WriteLine("");
		}

		public static void Debug(params Object[] args)
		{
			LogLevel(.Debug, params args);
		}

		public static void Error(params Object[] args)
		{
			LogLevel(.Error, params args);
		}

		public static void Info(params Object[] args)
		{
			LogLevel(.Info, params args);
		}

		public static void Warn(params Object[] args)
		{
			LogLevel(.Warn, params args);
		}

		public static void Log(params Object[] args)
		{
			LogLevel(mDisplayLevel, params args);
		}

		public static void LogLevel(LogLevel level, params Object[] args)
		{
			if (level > mDisplayLevel)
				return;
			System.Diagnostics.Debug.Write("[{}][{}] ", level, System.DateTime.Now.TimeOfDay);

			for (var i < args.Count)
			{
				System.Diagnostics.Debug.Write("{}", args[i]);
				if (i < args.Count - 1)
					System.Diagnostics.Debug.Write(", ");
			}
			System.Diagnostics.Debug.WriteLine("");
		}

		public static void LogArray<T>(T[,] array, int height, int width, System.String fileName = System.Compiler.CallerFileName, int lineNum = System.Compiler.CallerLineNum)
		{
			System.Diagnostics.Debug.WriteLine("[{}] [{:000}:{}] ", System.DateTime.Now.TimeOfDay, fileName, lineNum);

			for (var y < height)
			{
				for (var x < width)
				{
					System.Diagnostics.Debug.Write("{:000}", array[y, x]);
					if (x < width - 1)
						System.Diagnostics.Debug.Write(", ");
				}
				System.Diagnostics.Debug.WriteLine("");
			}
			System.Diagnostics.Debug.WriteLine("");
		}

		private static void Write(String line)
		{
		}

		private static void WriteLine(String line)
		{
			line.Append('\n');
			//if (BitConverter)
		}
	}
}
