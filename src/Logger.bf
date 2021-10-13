using System;
namespace BasicEngine
{
	static class Logger
	{
		public static void Log(System.String fileName = System.Compiler.CallerFileName, int lineNum = System.Compiler.CallerLineNum, params Object[] args)
		{
			System.Diagnostics.Debug.Write("[{:00}:{:00}:{:00}] [{:000}:{}] ", System.DateTime.Now.Hour, System.DateTime.Now.Minute, System.DateTime.Now.Second, fileName, lineNum);

			for(var i < args.Count)
			{
				System.Diagnostics.Debug.Write("{}", args[i]);
				if(i < args.Count-1)
					System.Diagnostics.Debug.Write(", ");

			}
			System.Diagnostics.Debug.WriteLine("");
		}
	}
}
