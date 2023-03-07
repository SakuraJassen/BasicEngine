using System;

namespace BasicEngine.Math
{
	struct BigDouble
	{
		public double val;//mantissa
		public int exp;//exponent

		static int EXPONENT_MASK = sizeof(double) == 8 ? 0x7FF0000000000000L : 0x7F800000;
		static int EXPONENT_UNMASK = sizeof(double) == 8 ? 0x800FFFFFFFFFFFFFL : 0x803FFFFF;
		static int EXPONENT_SET = sizeof(double) == 8 ? 0x3FF0000000000000L : 0x3F800000;
		static int EXPONENT_SHIFT = sizeof(double) == 8 ? 52 : 23;
		static int EXPONENT_BIAS = sizeof(double) == 8 ? 1023 : 127;

		static int MAX_PREC = sizeof(double) == 8 ? 53 : 24;
		// MIN_EXPONENT is smaller than you might expect, this is to give headroom for
		// avoiding overflow in + and other functions. it is the exponent for 0.0
		static int EXP_MIN = sizeof(double) == 8 ? int(-0x800000000000000L) : int(-0x08000000);
		static int EXP_MAX = -EXP_MIN;

		public this()
		{
			this = default;
		}

		public this(double mantissa, int exponent)
		{
			val = mantissa;
			exp = exponent;
		}

		public this(int mantissa)
		{
			val = mantissa;
			exp = 0;
		}

		public this(double value)
		{
			val = Math.Frexp(value, var exponent);
			exp = exponent;
		}

		public static operator double(BigDouble f)
		{
			return Math.Ldexp(f.val, f.exp);
		}

		public static BigDouble operator-(BigDouble f)
		{
			return BigDouble(-f.val, f.exp);
		}

		public void operator+=(BigDouble rhs) mut
		{
			this = this + rhs;
		}

		public static BigDouble operator+(BigDouble lhs, BigDouble rhs)
		{
			BigDouble r = BigDouble();
			int diff = 0;
			if (lhs.exp > rhs.exp)
			{
				diff = lhs.exp - rhs.exp;
				r.exp = lhs.exp;
				if (diff > MAX_PREC)
					r.val = lhs.val;
				else
				{
					double aval = setExp(rhs.val, -diff);
					r.val = lhs.val + aval;
				}
			}
			else
			{
				diff = rhs.exp - lhs.exp;
				r.exp = rhs.exp;
				if (diff > MAX_PREC)
					r.val = rhs.val;
				else
				{
					double aval = setExp(lhs.val, -diff);
					r.val = rhs.val + aval;
				}
			}

			return r;
		}

		public void operator-=(BigDouble rhs) mut
		{
			this = this - rhs;
		}
		public static BigDouble operator-(BigDouble lhs, BigDouble rhs)
		{
			BigDouble r = BigDouble();
			int diff = 0;
			if (lhs.exp > rhs.exp)
			{
				diff = lhs.exp - rhs.exp;
				r.exp = lhs.exp;
				if (diff > MAX_PREC)
					r.val = lhs.val;
				else
				{
					double aval = setExp(rhs.val, -diff);
					r.val = lhs.val - aval;
				}
			}
			else
			{
				diff = rhs.exp - lhs.exp;
				r.exp = rhs.exp;
				if (diff > MAX_PREC)
					r.val = rhs.val;
				else
				{
					double aval = setExp(lhs.val, -diff);
					r.val = rhs.val - aval;
				}
			}

			return r;
		}

		public void operator*=(BigDouble rhs) mut
		{
			val *= rhs.val;
			exp += rhs.exp;
		}

		public static BigDouble operator*(BigDouble lhs, BigDouble rhs)
		{
			return BigDouble(lhs.val * rhs.val, lhs.exp + rhs.exp);
		}

		public static BigDouble operator*(int lhs, BigDouble rhs)
		{
			var bigLhs = BigDouble(lhs);
			return BigDouble(bigLhs.val * rhs.val, bigLhs.exp + rhs.exp);
		}

		public void operator/=(BigDouble rhs) mut
		{
			val /= rhs.val;
			exp -= rhs.exp;
		}

		public static BigDouble operator/(BigDouble lhs, BigDouble rhs)
		{
			return BigDouble(lhs.val / rhs.val, lhs.exp - rhs.exp);
		}

		public BigDouble mul2() mut
		{
			BigDouble r;
			r.val = val;
			r.exp = exp + 1;// FIXME saturate
			return r;
		}

		static double setExp(double val, int exp)
		{
			double ret = val;
			int val_i = 0;
			Internal.MemCpy(&val_i, &ret, sizeof(int));
			val_i = (val_i & EXPONENT_UNMASK) | ((exp + EXPONENT_BIAS) << EXPONENT_SHIFT);
			Internal.MemCpy(&ret, &val_i, sizeof(int));
			return val;
		}

		public override void ToString(String strBuffer)
		{
			//base.ToString(strBuffer);
			double lf = Math.Log10(Math.Abs(val)) + exp * Math.Log10(2.0);
			int e10 = (int)Math.Floor(lf);
			double d10 = Math.Pow(10, lf - e10) * (val <=> 0);
			strBuffer.AppendF($"{e10}E{d10}");
		}
	}
}
