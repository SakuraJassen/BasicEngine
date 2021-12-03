using System;
namespace BasicEngine.Debug
{
	static class Logger
	{
		public static void Log(System.String fileName = System.Compiler.CallerFileName, int lineNum = System.Compiler.CallerLineNum, params Object[] args)
		{
			System.Diagnostics.Debug.Write("[{}] [{:000}:{}] ", System.DateTime.Now.TimeOfDay, fileName, lineNum);

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
	}
}
