using System.Collections;
namespace BasicEngine
{
}

static
{
	/*public static mixin NOP()
	{
	}*/

	public static mixin SDLError(int err)
	{
		if (err != 0)
		{
			BasicEngine.Debug.Logger.Debug("SDLERR");
			BasicEngine.Debug.Logger.LogMeta(System.Compiler.CallerFileName, System.Compiler.CallerLineNum);
			BasicEngine.Debug.Logger.Error(scope System.String(SDL2.SDL.GetError()));
		}
	}

	public static mixin SafeDelete(var obj)
	{
		if (obj != null)
			delete obj;
	}

	public static mixin SafeDeleteNullify(var obj)
	{
		if (obj != null)
			DeleteAndNullify!(obj);
	}

	public static mixin GetAndRemove<T>(List<T> obj, int index)
	{
		T ret = obj[index];
		obj.RemoveAt(index);
		ret
	}

	public static mixin SafeMemberSet(var obj, var val)
	{
		if (obj != null)
			delete obj;
		obj = val;
	}

	public static mixin ToGlobalString(var obj)
	{
		var str = new System.String();
		obj.ToString(str);
		str
	}

	public static mixin GlobalStringFormat(System.String format, var arg1)
	{
		var str = new System.String();
		str.AppendF(format, arg1);
		str
	}

	public static mixin GlobalStringFormat(System.String format, var arg1, var arg2)
	{
		var str = new System.String();
		str.AppendF(format, arg1, arg2);
		str
	}

	public static mixin GlobalStringFormat(System.String format, var arg1, var arg2, var arg3)
	{
		var str = new System.String();
		str.AppendF(format, arg1, arg2, arg3);
		str
	}
	//public static void LogMeta(System.String fileName = System.Compiler.CallerFileName, int line =
	// System.Compiler.CallerLineNum)
	public static mixin LogMeta()
	{
		//System.Diagnostics.Debug.Write("[{:00}:{:00}:{:00}] [{:000}:{}] ", System.DateTime.Now.Hour, System.DateTime.Now.Minute, System.DateTime.Now.Second, System.Compiler.CallerFileName, System.Compiler.CallerLineNum);
		BasicEngine.Debug.Logger.LogMeta();
	}

	public static mixin Log(var obj1)
	{
#if DEBUG
		BasicEngine.Debug.Logger.Debug(System.Compiler.CallerFileName, System.Compiler.CallerLineNum, obj1);
#endif
	}

	public static mixin LogN(var obj1)
	{
#if DEBUG 
		System.Diagnostics.Debug.Write("{}", obj1);
		System.Diagnostics.Debug.WriteLine(" ");
#endif
	}

	public static mixin Log(var obj1, var obj2)
	{
#if DEBUG
		BasicEngine.Debug.Logger.Debug(System.Compiler.CallerFileName, System.Compiler.CallerLineNum, obj1, obj2);
#endif
	}


	public static mixin LogN(var obj1, var obj2)
	{
#if DEBUG 
		System.Diagnostics.Debug.Write("{}, ", obj1);
		System.Diagnostics.Debug.Write("{}", obj2);
		System.Diagnostics.Debug.WriteLine(" ");
#endif
	}

	public static mixin Log(var obj1, var obj2, var obj3)
	{
#if DEBUG
		BasicEngine.Debug.Logger.Debug(System.Compiler.CallerFileName, System.Compiler.CallerLineNum, obj1, obj2, obj3);
#endif
	}

	public static mixin LogN(var obj1, var obj2, var obj3)
	{
#if DEBUG
		System.Diagnostics.Debug.Write("{}, ", obj1);
		System.Diagnostics.Debug.Write("{}, ", obj2);
		System.Diagnostics.Debug.Write("{}", obj3);
		System.Diagnostics.Debug.WriteLine(" ");
#endif
	}
}
