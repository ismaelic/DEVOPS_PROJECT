public with sharing class DataDataJSON2Apex {
    public List<Data_Z> data;

	public class Data_Z {
		public List<Data> data;
		public String name;
	}

	
	public static DataDataJSON2Apex parse(String json) {
		return (DataDataJSON2Apex) System.JSON.deserialize(json, DataDataJSON2Apex.class);
	}
}
