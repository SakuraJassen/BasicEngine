using System;
using System.Collections;
using BasicEngine.Collections;

namespace BasicEngine.Console
{
	class Toggle : Command
	{
		public this() : base("toggle", 1, "Toggles a GameRule") {

		}

		public override bool Run(List<String> args)
		{
			bool val;
			int index;

			switch(CommandUtils.FindGameRule(args[1]))
			{
			case .Ok(let ni):
				args[1].Clear();
				args[1].Append(ToStackString!(ni.mName));
				val = !gEngineApp.mGameRules.GetBit(ni.mStartIndex);
				index = ni.mStartIndex;
				gEngineApp.mGameRules.SetBit(index, val);
			case .Err: 
			}

			switch(int.Parse(args[1]))
			{
			case .Ok(let i):
				val = !gEngineApp.mGameRules.GetBit(i);
				index = i;
				gEngineApp.mGameRules.SetBit(i, val);
			case .Err: return false;
			}

			gEngineApp.mCmd.SendMassage("Toggled bit {} to {}", index, val );
			return true;
		}

		public override Command Create()
		{
			return new Self();
		}
	}
}
