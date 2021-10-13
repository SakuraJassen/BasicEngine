using System;
using System.Collections;
using BasicEngine.Collections;

namespace BasicEngine.Console
{
	class BitSet : Command
	{
		public this() : base("bitset", 2, "Sets a bit to a bool value") {

		}

		public override bool Run(List<String> args)
		{
			int index = -1;
			int value = -1;

			if((args[2] != bool.FalseString && args[2] != bool.TrueString) && (args[2] != "1" && args[2] != "0"))
				return false;

			if(args[2] == "1" || args[2] == "0")
			{
				switch(int.Parse(args[1]))
				{
				case .Ok(let i):
					switch(int.Parse(args[2]))
					{
					case .Ok(let v):
						gEngineApp.mGameRules.SetBit(i, BitArray.toBool(v));
						index = i;
						value = v;
					case .Err: return false;
					}
				case .Err:
				}
			}
			else
				return false;
		
			gEngineApp.mCmd.SendMassage("Set bit {} to {}", index, value);

			return true;
		}

		uint8 Parse(StringView string)
		{
			if(string == bool.TrueString)
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
