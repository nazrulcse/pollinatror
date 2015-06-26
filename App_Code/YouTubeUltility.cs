using System;
using System.Configuration;
using System.Threading.Tasks;
using System.Web;
using Google.GData.Client;
using Google.GData.Client.ResumableUpload;
using Google.GData.Extensions.MediaRss;
using Google.GData.YouTube;
using Google.YouTube;

/// <summary>
/// Summary description for YouTubeUltility
/// </summary>
public class YouTubeUltility
{
    public YouTubeUltility()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public string uploadId;
    public string videoId;
    public int uploadProgess;
    public State videoStatus;

    private static YouTubeRequest GetRequest()
    {
        var youtubeApiKey = ConfigurationManager.AppSettings["youtubeApiKey"];
        var applicationName = ConfigurationManager.AppSettings["applicationName"];
        var youtubeUserName = ConfigurationManager.AppSettings["youtubeUserName"];
        var youtubePassword = ConfigurationManager.AppSettings["youtubePassword"];
        var settings = new YouTubeRequestSettings(applicationName, youtubeApiKey, youtubeUserName, youtubePassword);
        var request = new YouTubeRequest(settings);
        return request;
    }

    public async Task UploadToYouTube(HttpPostedFile postedFile, string title)
    {
        UploadingDispatcher.SetProgress(uploadId, 2);
        Video video = new Video();
        video.Title = title;
        video.Tags.Add(new MediaCategory("Autos", YouTubeNameTable.CategorySchema));
        video.Private = false;
        video.MediaSource = new MediaFileSource(postedFile.InputStream, postedFile.FileName, postedFile.ContentType);

        var link = new AtomLink("http://uploads.gdata.youtube.com/resumable/feeds/api/users/default/uploads");
        link.Rel = ResumableUploader.CreateMediaRelation;
        video.YouTubeEntry.Links.Add(link);

        var youtubeApiKey = ConfigurationManager.AppSettings["youtubeApiKey"];
        var applicationName = ConfigurationManager.AppSettings["applicationName"];
        var youtubeUserName = ConfigurationManager.AppSettings["youtubeUserName"];
        var youtubePassword = ConfigurationManager.AppSettings["youtubePassword"];
        var youtubeChunksize = int.Parse(ConfigurationManager.AppSettings["youtubeChunksize"]);

        var resumableUploader = new ResumableUploader(youtubeChunksize); 
        resumableUploader.AsyncOperationCompleted += resumableUploader_AsyncOperationCompleted;
        resumableUploader.AsyncOperationProgress += resumableUploader_AsyncOperationProgress;

      
        var youTubeAuthenticator = new ClientLoginAuthenticator(applicationName, ServiceNames.YouTube, youtubeUserName, youtubePassword);
        youTubeAuthenticator.DeveloperKey = youtubeApiKey;

        resumableUploader.InsertAsync(youTubeAuthenticator, video.YouTubeEntry, uploadId);
    }


    private void resumableUploader_AsyncOperationCompleted(object sender, AsyncOperationCompletedEventArgs e)
    {
        try
        {
            var request = GetRequest();
            Video video = request.ParseVideo(e.ResponseStream);
            videoId = video.VideoId;
            videoStatus = video.Status;
            UploadingDispatcher.SetProgress(uploadId, 100);
        }
        catch (Exception ex)
        {
            //Upload has been disturbed.
        }

    }

    private void resumableUploader_AsyncOperationProgress(object sender, AsyncOperationProgressEventArgs progress)
    {
        var uploadProgess = progress.ProgressPercentage;
        UploadingDispatcher.SetProgress(uploadId, uploadProgess);
    }

    public bool CheckStatus(string videoId)
    {
        YouTubeRequest request;
        Video video = RetrieveVideo(videoId, out request);
        if (video.IsDraft)
            videoStatus = video.Status;
        return video.IsDraft;
    }

    public void DeleleVideoYouTube(string videoId)
    {
        var request = GetRequest();
        Uri videoEntryUrl = new Uri(String.Format("http://gdata.youtube.com/feeds/api/users/default/uploads/{0}", videoId));       
        try
        {
            Video video = request.Retrieve<Video>(videoEntryUrl);
            request.Delete(video);
        }
        catch (Exception ex)
        {
        }
    }

    public Video RetrieveVideo(string videoId, out YouTubeRequest request)
    {
        try
        {
            request = GetRequest();
            Uri videoEntryUrl = new Uri("http://gdata.youtube.com/feeds/api/videos/" + videoId);
            Video video = request.Retrieve<Video>(videoEntryUrl);
            return video;
        }         
        catch (Exception ex)
        {
            request = null;
            return null;
        }
    }
}