using System.Diagnostics;
using System.Reflection;
using Microsoft.AspNetCore.Mvc;
using Enterprise.Platform.MyService.Api.Models;

namespace Enterprise.Platform.MyService.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class Health : ControllerBase
{
    //[HttpGet(Name = "version")]
    public ActionResult<FileVersionInfo> Get()
    {
        var versionInfo = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location);
        return Ok(versionInfo);
    }
}
