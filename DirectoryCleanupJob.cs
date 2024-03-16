using System.Management.Automation;
using System.Management.Automation.Runspaces;

public class DirectoryCleanupJob
{
    public static void Main(string[] args)
    {
        RunScript(@"C:\Coding Projects\PowerShell\DirectoryCleanupJob\DirectoryCleanupJob.ps1");
    }

    public static ICollection<PSObject> RunScript(string scriptFullPath, ICollection<CommandParameter>? commandParameters = null)
    {
        using (var runspace = RunspaceFactory.CreateRunspace())
        {
            using (var pipeline = runspace.CreatePipeline())
            {
                var command = new Command(scriptFullPath);
                if (commandParameters != null)
                {
                    foreach (var parameter in commandParameters)
                    {
                        command.Parameters.Add(parameter);
                    }
                }
                pipeline.Commands.Add(command);
                var results = pipeline.Invoke();
                return results;
            }
        }
    }
}
