using BasicEngine.Collections;
using System;

namespace BasicEngine.Console
{
	static class CommandUtils
	{
		public static Result<NamedIndex> FindGameRule(String string)
		{
			switch (gEngineApp.mGameRules.mNamedIndices.FindByName(string))
			{
			    case .Ok(let index):
					return .Ok(index);
			    case .Err: return .Err;
			}
		}
	}
}
