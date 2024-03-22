using System.Management.Automation;
using System.Management.Automation.Runspaces;

public class Runner
{
    public static void Main(string[] args)
    {
        RunScript(@"C:\Coding Projects\PowerShell\DirectoryCleanupJob\DirectoryCleanupJob.ps1");
        
        var cmdParamList = new List<CommandParameter>
        {
            new CommandParameter("Path", @"C:\Coding Projects\PowerShell\DirectoryCleanupJob\bin")
        };
        RunScript(@"C:\Coding Projects\PowerShell\DirectoryCleanupJob\ShowBinAssemblyVersions.ps1", cmdParamList);
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
