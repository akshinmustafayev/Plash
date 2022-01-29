using System;
using System.Collections.Generic;

public class Table
{
	public List<string> TableData = new List<string>();
	private bool AddHeaderRepeated = false;

    public Table()
    {
        TableData.Add("<table class=\"table\">");
        TableData.Add("</table>");
    }

    public void AddHeader(string[] values)
    {
		if(AddHeaderRepeated == false){
			AddHeaderRepeated = true;
			string tHead = "";
			foreach(string value in values){
				tHead += "<th>" + value + "</th>";
			}
			TableData.Insert(1, "<tr>" + tHead + "</tr>");
		}
    }
	
	public void AddRow(string[] rows)
    {
		string tRows = "";
		foreach(string row in rows){
			tRows += "<td>" + row + "</td>";
		}
        TableData.Insert(TableData.Count - 1, "<tr>" + tRows + "</tr>");
    }

    public void RemoveTableHeader()
    {
		if(TableData[1].Contains("<th>") && TableData[1].Contains("</th>"))
		{
            AddHeaderRepeated = false;
			TableData.RemoveAt(1);
		}
    }
	
	public void ClearTableData()
    {
        List<string> TempTableData = new List<string>();

		if(TableData[1].Contains("<th>") && TableData[1].Contains("</th>"))
		{
			for (int i = 0; i < TableData.Count; i++) 
			{
                if(i == 0 || i == 1 || i == TableData.Count - 1)
                {
                    TempTableData.Add(TableData[i]);
                }
			}
		}
        else
        {
            for (int i = 0; i < TableData.Count; i++) 
            {
                if(i == 0 || i == TableData.Count - 1)
                {
                    TempTableData.Add(TableData[i]);
                }
            }
        }
        
        TableData = TempTableData;
    }

	public void SetTableStyleHTML(string style)
    {
        TableData[0] = "<table class=\"table\" style=\"" + style + "\">";
    }

    public string GetTable()
    {
        return String.Join("", TableData.ToArray());
    }
}
