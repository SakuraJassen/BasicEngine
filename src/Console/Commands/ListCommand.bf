using System;
using System.Collections;

namespace BasicEngine.Console
{
	class ListCommand : Command
	{
		public this() : base("list", 0, "List the available Gamerules") {

		}

		public override bool Run(List<String> args)
		{
			System.Diagnostics.Debug.WriteLine("list");
			for(int i < gEngineApp.mGameRules.mNamedIndices.[Friend]mNamedIndices.Count)
			{
				var ni = gEngineApp.mGameRules.mNamedIndices.[Friend]mNamedIndices[i];
				gEngineApp.mCmd.SendMassage("{}\t:\t'{}'\t= {}", i, ni, gEngineApp.mGameRules.GetRange(ni));
			}
			return true;
		}

		public override Command Create()
		{
			return new Self();
		}
	}
}
