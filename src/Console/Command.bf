using System;
using System.Collections;

namespace BasicEngine.Console
{
	class Command
	{
		String mCommandText;
		public readonly String CommandText
		{
			get
			{
				return mCommandText;
			}
		}

		int mParamCount = 0;
		public readonly int ParamCounter
		{
			get
			{
				return mParamCount;
			}
		}

		String mHelpText;
		public readonly String HelpText
		{
			get
			{
				return mHelpText;
			}
		}

		protected this() {}

		protected this(String cmdText, int paramC)
		{
			mCommandText = cmdText;
			mParamCount = paramC;
		}

		protected this(String cmdText, int paramC, String help) : this(cmdText, paramC)
		{
			mHelpText = help;
		}

		public virtual bool Run(List<String> args)
		{
			System.Diagnostics.Debug.WriteLine("Base Command ran! Missing an overload?");
			return false;
		}

		public virtual Self Create()
		{
			System.Diagnostics.Debug.WriteLine("Base Create called! Missing an overload?");
			return new Self();
		}
	}
}
