using System;
using System.Collections;

namespace BasicEngine.Console
{
	class Help : Command
	{
		public this() : base("help", 0, "shows this massage") {

		}

		public override bool Run(List<String> args)
		{
			System.Diagnostics.Debug.WriteLine("help");
			return true;
		}

		public override Command Create()
		{
			return new Self();
		}
	}
}
