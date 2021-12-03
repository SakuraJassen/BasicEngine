namespace System
{
	extension Random
	{
		public double RandomGaussian(float mean = 0, float stdDev = 1)
		{
			double u1 = 1.0 - NextDouble();//uniform(0,1] random doubles
			double u2 = 1.0 - NextDouble();
			double randStdNormal = Math.Sqrt(-2.0 * Math.Log(u1)) *
				Math.Sin(2.0 * Math.PI_d * u2);//random normal(0,1)
			double randNormal =
				mean + stdDev * randStdNormal;//random normal(mean,stdDev^2)

			return randNormal;
		}
	}
}
