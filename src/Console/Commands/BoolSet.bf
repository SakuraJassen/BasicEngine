using System;
using System.Collections;
using BasicEngine.Collections;

namespace BasicEngine.Console
{
	class BoolSet : Command
	{
		public this() : base("boolset", 2, "Sets a Gamerule to a bool value")
		{
		}

		public override bool Run(List<String> args)
		{
			NamedIndex namedIndex;
			bool? value = null;

			/*if((args[2] != bool.FalseString && args[2] != bool.TrueString) && (args[2] != "1" && args[2] != "0"))
				return false;*/

			switch (CommandUtils.FindGameRule(args[1]))
			{
			case .Ok(let ni):
				if (ni.Size > 1)
					return false;
				args[1].Clear();
				args[1].Append(ToStackString!(ni.mName));
				switch (int.Parse(args[2]))
				{
				case .Ok(let v):
					gEngineApp.mGameRules.SetRange(ni, (uint64)v);
					namedIndex = ni;
					value = v == 1;
				case .Err:
					switch (bool.Parse(args[2]))
					{
					case .Ok(let v):
						if (v)
						{
							gEngineApp.mGameRules.SetRange(ni, 1);
						}
						else
						{
							gEngineApp.mGameRules.SetRange(ni, 0);
						}

						namedIndex = ni;
						value = v;
					case .Err:
						return false;
					}
				}
			case .Err: return false;
			}

			gEngineApp.mCmd.SendMassage("Set bit {} to {}", namedIndex?.mName, value);


			return true;
		}

		uint8 Parse(StringView string)
		{
			if (string == bool.TrueString)
				return 1;
			else
				return 0;
		}

		public override Command Create()
		{
			return new Self();
		}
	}
}
