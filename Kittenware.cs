using System;
using System.IO;
using System.Net;
using Microsoft.Win32;

class Program
{
    static void Main(string[] args)
    {
        // Define the path to the images directory
        string imagesDirectory = Environment.ExpandEnvironmentVariables("%userprofile%/images");

        // Check if the directory exists, if not create it
        if (!Directory.Exists(imagesDirectory))
        {
            Directory.CreateDirectory(imagesDirectory);
        }

        // Download random images of kittens and save them to the images directory
        DownloadRandomImages("kittens", imagesDirectory);

        // Schedule the program to run every hour
        ScheduleTask();
    }

    static void DownloadRandomImages(string searchTerm, string saveDirectory)
    {
        // Code to download random images of kittens and save them to the specified directory
    }

    static void ScheduleTask()
    {
        // Get the path of the current executable
        string exePath = System.Reflection.Assembly.GetExecutingAssembly().Location;

        // Create a new task definition
        using (TaskService ts = new TaskService())
        {
            TaskDefinition td = ts.NewTask();
            td.RegistrationInfo.Description = "Download random kitten images every hour";

            // Create a trigger that will fire the task at startup
            td.Triggers.Add(new LogonTrigger());

            // Create an action that will launch the current executable
            td.Actions.Add(new ExecAction(exePath));

            // Register the task to run as the current user
            ts.RootFolder.RegisterTaskDefinition(@"KittenImages", td);
        }
    }
}
