namespace System
{
	extension String
	{
		public void Truncate(float val, int digits)
		{
			let buffer = scope String(256);
			double fraction = Math.TruncateDecimal(val);
			fraction.ToString(buffer);
			this.AppendF("{}.", (int)val);
			for (int i = 2; i < digits + 2; i++)
			{
				if (i < buffer.Length)
					this.AppendF("{}", buffer[i]);
			}
		}

		public void TruncateF(String prefix, float val, int digits)
		{
			let buffer = scope String(256);
			double fraction = Math.TruncateDecimal(val);
			fraction.ToString(buffer);

			this.Append(prefix);
			this.AppendF("{}.", (int)val);

			for (int i = 2; i < digits + 2; i++)
			{
				if (i < buffer.Length)
					this.AppendF("{}", buffer[i]);
			}
		}
	}
}
