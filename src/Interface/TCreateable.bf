namespace BasicEngine.Interface
{
	interface TCreateable
	{
		public virtual Self* Create()
		{
			return new Self();
		}
	}
}
