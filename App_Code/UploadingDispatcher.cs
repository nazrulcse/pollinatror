using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for UploadingDispatcher
/// </summary>
public static class UploadingDispatcher
{
    private static Dictionary<string, Int32> Uploads = new Dictionary<string, Int32>();
    private static object syncRoot = new object();

    public static void Add(string id)
    {
        lock (syncRoot)
        {
            Uploads.Add(id, 0);
        }
    }

    public static void Remove(string id)
    {
        lock (syncRoot)
        {
            Uploads.Remove(id);
        }
    }

    public static int GetProgress(string id)
    {
        lock (syncRoot)
        {
            if (Uploads.ContainsKey(id))
            {
                return Uploads[id];
            }
            return 0;
        }
    }

    public static Boolean SetProgress(string id, Int32 value)
    {
        lock (syncRoot)
        {
            if (Uploads.ContainsKey(id))
            {
                Uploads[id] = value;
                return true;
            }
            return false;
        }
    }
}