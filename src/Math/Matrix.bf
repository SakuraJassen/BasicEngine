namespace BasicEngine.Math
{
	class Matrix
	{
		public float m11;
		public float m12;
		public float m13;
		public float m14;

		public float m21;
		public float m22;
		public float m23;
		public float m24;

		public float m31;
		public float m32;
		public float m33;
		public float m34;

		public float m41;
		public float m42;
		public float m43;
		public float m44;


		public this()
			{ }

		public this(Matrix m) : this(m.m11, m.m12, m.m13, m.m14,
			m.m21, m.m22, m.m23, m.m24,
			m.m31, m.m32, m.m33, m.m34,
			m.m41, m.m42, m.m43, m.m44)
		{
		}

		public this(float c11, float c12, float c13, float c14,
			float c21, float c22, float c23, float c24,
			float c31, float c32, float c33, float c34,
			float c41, float c42, float c43, float c44)
		{
			m11 = c11;
			m12 = c12;
			m13 = c13;
			m14 = c14;

			m21 = c21;
			m22 = c22;
			m23 = c23;
			m24 = c24;

			m31 = c31;
			m32 = c32;
			m33 = c33;
			m34 = c34;

			m41 = c41;
			m42 = c42;
			m43 = c43;
			m44 = c44;
		}

		public static bool operator==(Matrix lhs, Matrix rhs)
		{
			return (
				lhs.m11 == rhs.m11 &&
				lhs.m12 == rhs.m12 &&
				lhs.m13 == rhs.m13 &&
				lhs.m14 == rhs.m14 &&
				lhs.m21 == rhs.m21 &&
				lhs.m22 == rhs.m22 &&
				lhs.m23 == rhs.m23 &&
				lhs.m24 == rhs.m24 &&
				lhs.m31 == rhs.m31 &&
				lhs.m32 == rhs.m32 &&
				lhs.m33 == rhs.m33 &&
				lhs.m34 == rhs.m34 &&
				lhs.m41 == rhs.m41 &&
				lhs.m42 == rhs.m42 &&
				lhs.m43 == rhs.m43 &&
				lhs.m44 == rhs.m44);
		}

		public static bool operator!=(Matrix lhs, Matrix rhs)
		{
			return !(lhs == rhs);
		}

		public static Matrix operator+(Matrix lhs, Matrix rhs)
		{
			return new Matrix(lhs.m11 + rhs.m11,
				lhs.m12 + rhs.m12,
				lhs.m13 + rhs.m13,
				lhs.m14 + rhs.m14,
				lhs.m21 + rhs.m21,
				lhs.m22 + rhs.m22,
				lhs.m23 + rhs.m23,
				lhs.m24 + rhs.m24,
				lhs.m31 + rhs.m31,
				lhs.m32 + rhs.m32,
				lhs.m33 + rhs.m33,
				lhs.m34 + rhs.m34,
				lhs.m41 + rhs.m41,
				lhs.m42 + rhs.m42,
				lhs.m43 + rhs.m43,
				lhs.m44 + rhs.m44);
		}

		public void operator+=(Matrix rhs)
		{
			m11 += rhs.m11;
			m12 += rhs.m12;
			m13 += rhs.m13;
			m14 += rhs.m14;
			m21 += rhs.m21;
			m22 += rhs.m22;
			m23 += rhs.m23;
			m24 += rhs.m24;
			m31 += rhs.m31;
			m32 += rhs.m32;
			m33 += rhs.m33;
			m34 += rhs.m34;
			m41 += rhs.m41;
			m42 += rhs.m42;
			m43 += rhs.m43;
			m44 += rhs.m44;
		}

		public static Matrix operator-(Matrix lhs, Matrix rhs)
		{
			return new Matrix(lhs.m11 - rhs.m11,
				lhs.m12 - rhs.m12,
				lhs.m13 - rhs.m13,
				lhs.m14 - rhs.m14,
				lhs.m21 - rhs.m21,
				lhs.m22 - rhs.m22,
				lhs.m23 - rhs.m23,
				lhs.m24 - rhs.m24,
				lhs.m31 - rhs.m31,
				lhs.m32 - rhs.m32,
				lhs.m33 - rhs.m33,
				lhs.m34 - rhs.m34,
				lhs.m41 - rhs.m41,
				lhs.m42 - rhs.m42,
				lhs.m43 - rhs.m43,
				lhs.m44 - rhs.m44);
		}

		public void operator-=(Matrix rhs)
		{
			m11 -= rhs.m11;
			m12 -= rhs.m12;
			m13 -= rhs.m13;
			m14 -= rhs.m14;
			m21 -= rhs.m21;
			m22 -= rhs.m22;
			m23 -= rhs.m23;
			m24 -= rhs.m24;
			m31 -= rhs.m31;
			m32 -= rhs.m32;
			m33 -= rhs.m33;
			m34 -= rhs.m34;
			m41 -= rhs.m41;
			m42 -= rhs.m42;
			m43 -= rhs.m43;
			m44 -= rhs.m44;
		}

		public static Matrix operator/(Matrix lhs, Matrix rhs)
		{
			return new Matrix(lhs.m11 / rhs.m11,
				lhs.m12 / rhs.m12,
				lhs.m13 / rhs.m13,
				lhs.m14 / rhs.m14,
				lhs.m21 / rhs.m21,
				lhs.m22 / rhs.m22,
				lhs.m23 / rhs.m23,
				lhs.m24 / rhs.m24,
				lhs.m31 / rhs.m31,
				lhs.m32 / rhs.m32,
				lhs.m33 / rhs.m33,
				lhs.m34 / rhs.m34,
				lhs.m41 / rhs.m41,
				lhs.m42 / rhs.m42,
				lhs.m43 / rhs.m43,
				lhs.m44 / rhs.m44);
		}

		public void operator/=(Matrix rhs)
		{
			m11 /= rhs.m11;
			m12 /= rhs.m12;
			m13 /= rhs.m13;
			m14 /= rhs.m14;
			m21 /= rhs.m21;
			m22 /= rhs.m22;
			m23 /= rhs.m23;
			m24 /= rhs.m24;
			m31 /= rhs.m31;
			m32 /= rhs.m32;
			m33 /= rhs.m33;
			m34 /= rhs.m34;
			m41 /= rhs.m41;
			m42 /= rhs.m42;
			m43 /= rhs.m43;
			m44 /= rhs.m44;
		}

		public static Matrix operator*(Matrix lhs, Matrix rhs)
		{
			return new Matrix(lhs.m11 * rhs.m11,
				lhs.m12 * rhs.m12,
				lhs.m13 * rhs.m13,
				lhs.m14 * rhs.m14,
				lhs.m21 * rhs.m21,
				lhs.m22 * rhs.m22,
				lhs.m23 * rhs.m23,
				lhs.m24 * rhs.m24,
				lhs.m31 * rhs.m31,
				lhs.m32 * rhs.m32,
				lhs.m33 * rhs.m33,
				lhs.m34 * rhs.m34,
				lhs.m41 * rhs.m41,
				lhs.m42 * rhs.m42,
				lhs.m43 * rhs.m43,
				lhs.m44 * rhs.m44);
		}

		public void operator*=(Matrix rhs)
		{
			m11 *= rhs.m11;
			m12 *= rhs.m12;
			m13 *= rhs.m13;
			m14 *= rhs.m14;
			m21 *= rhs.m21;
			m22 *= rhs.m22;
			m23 *= rhs.m23;
			m24 *= rhs.m24;
			m31 *= rhs.m31;
			m32 *= rhs.m32;
			m33 *= rhs.m33;
			m34 *= rhs.m34;
			m41 *= rhs.m41;
			m42 *= rhs.m42;
			m43 *= rhs.m43;
			m44 *= rhs.m44;
		}
		public static Matrix operator*(Matrix lhs, float rhs)
		{
			return new Matrix();
		}

		public void operator*=(float rhs)
		{
		}

		public static Matrix operator/(Matrix lhs, float rhs)
		{
			return new Matrix();
		}

		public void operator/=(float rhs)
		{
		}


	}
}
