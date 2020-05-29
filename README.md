# robocopy-backup

This script allows you to robustly and easily backup data to any location (local or network). It uses robocopy, a Windows system tool that doesn't have to be installed or configured. For more information on robocopy and for additional options visit [TechNet](https://technet.microsoft.com/en-GB/library/cc733145.aspx).


## Tutorial

### Setting up the script

The script as provided is a dummy. To make it functional you need to give it locations to copy. The easiest way to do so is right-click on it and select "Edit". A more convenient way is to use a code editor such as [Visual Studio Code](https://www.visualstudio.com/en-us/products/code-vs.aspx) or [Sublime Text](https://www.sublimetext.com/). 

Find the line saying 

```
robocopy <Source> <Destination> /e /xo /np /z /r:10 /w:1 /mt:4 /log:%SAVESTAMP% /tee
```

And replace <Source> with the file path of the folder to be backed up and <Destination> with the file path of the backup location. File paths with blank spaces need to go between quotation marks, and you should not add a trailing backslash as is often seen with file paths. The result should look like this:

```
robocopy C:\myFiles "Y:\backup\my files" /e /xo /np /z /r:2 /w:1 /mt:4 /log:%SAVESTAMP% /tee
```

This works. Note the quotation marks and the lack of trailing backslash! The following line would not work:

```
robocopy C:\myFiles Y:\backup\my files /e /xo /np /z /r:2 /w:1 /mt:4 /log:%SAVESTAMP% /tee
```

Don't worry if the script doesn't run on the first try, as long as you don't fiddle with anything else than ```<Source>``` and ```<Destination>``` you can't really break anything.

If you want to back up more than one folder, copy the whole code block

```
robocopy <Source> <Destination> /e /xo /np /z /r:10 /w:1 /mt:4 /log:%SAVESTAMP% /tee
if errorlevel 8 (
	SET ERRORFLAG=1
)
```

including the if statement as many times as you need and adjust the file paths accordingly.

Last but not least you need to specify a path for the logfile. Otherwise you might run into troubles when using the Task Scheduler. Robocopy by default dumps the logfile into the same location as the script is sitting and if you call the script via Task Scheduler it (for whatever reason) tries to dump the file into System32 and it most likely doesn't have the permission to do so. Therefore you need to give it a path. 

Find the line saying

```
SET "LOGPATH=some path"
```

and replace ```some path``` with the path to the folder where you want your logfiles to go. Again no trailing backslash, but no quotation marks this time (they are already provided). 

### Scheduling the task

Put the script into a folder that is NOT any of the folders to be backed up. I highly recommend making a folder SCRIPTS in the root directory (C:\SCRIPTS) and dumping it there. Alternatively the documents folder works as well. Avoid putting it on the desktop since it will spam it full with log files!

To make it run by itself we use the Windows Task Scheduler. You can find it by typing "Task Scheduler" into the search bar (all Windows versions). Open it, and on the "Actions" panel on the right click "Create Basic Task..."

A Wizard opens, prompting you for a name and a description. Give it something and click Next. Select any schedule (Daily, Weekly, etc), and set the start date and the time it should run. Note: robocopy scans all the files at the Destination first and then starts to copy, and that can be epically slow, especially if you have many small files or use the WiFi. So I would advise you to select some time in the night like 3am. Click next. Select "Start a program", click next. 

Now it asks you for the location of the script. Click "Browse..." and find the location of the batch file. Select the batch file and click "Open". Leave the arguments and "Open in..." lines blank and click next. Review the entries, tick "Open the Properties dialog for this task when I click Finish", and click finish.

In order to work properly you need to untick a few boxes. In the "Conditions" tab, untick "Start the task only if the computer is on AC power". In the "Settings" tab untick "Stop the task if it runs longer than:" and "If the running task does not end when requested, force it to stop". We want it to remain open and notify us if there has been a problem!

Click OK and you are done!

### Additional options

robocopy is an incredibly powerful tool. The script as provided creates backups of every file and folder, even empty ones, and does not delete anything any more on the backup side, even if it gets deleted on the source. This might not suit your purposes, or you might want to exclude files or folders. To modify the behaviour just edit the options (all the stuff after ```robocopy <Source> <Destination>``` that begins with a slash). For a complete list of optins visit [TechNet](https://technet.microsoft.com/en-GB/library/cc733145.aspx).