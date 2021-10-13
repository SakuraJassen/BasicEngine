using System;
using System.Collections;
using BasicEngine.Collections;

namespace BasicEngine.Console
{
	class Set : Command
	{
		public this() : base("set", 2, "Sets a GameRule to a value")
		{
		}

		public override bool Run(List<String> args)
		{
			switch (CommandUtils.FindGameRule(args[1]))
			{
			case .Ok(let ni):
				args[1].Clear();
				args[1].Append(ToStackString!(ni.mName));
				switch (int.Parse(args[2]))
				{
				case .Ok(let val): gEngineApp.mGameRules.SetRange(ni, (uint64)val);
				case .Err: return false;
				}
			case .Err: return false;
			}

			return true;
		}

		public override Command Create()
		{
			return new Self();
		}
	}
}
