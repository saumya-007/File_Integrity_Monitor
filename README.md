# File_Integrity_Monitor
This is a basic File Integrity Montor which is made using windows powershell. It contineously monitors files in a folder and alerts the user on the terminal when some file in the folder is either modified, added, deleted.

- For simplicity i have given a folder and file in this git repository, but you can do it for any folder you want jsut make sure that folder structure remains the same as this git repository.
- First a baseline.txt is created which stores the items already present in the folder with a hash value assigned to it. I have already created a baseline but you can run the script and create a new baseline as per your convenience.
- When ever the script is activated the program starts montioring the folder and an alert is generated whenever their are the following changes: *Addition of a new file, Deletion of a file, Modification of the content of the present file.*
- For doing so the program calculates the hash value and stroes the related information in baseline. Upon activation of the script the hash value is monitored and when ever a parameters like hash, path, number of files in the folder is changed an alert is generated on the terminal with appropriate color.
