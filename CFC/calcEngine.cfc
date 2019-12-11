component output="false" displayname="Calc/Conversion Opertions"  {

	public function RadianToDegrees(required radian){

		degrees = arguments.radian * 180 / pi();

		return degrees;

	}

}