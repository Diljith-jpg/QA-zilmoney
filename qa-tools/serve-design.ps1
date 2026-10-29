param([string]$Root, [int]$Port = 8765)
$l = New-Object System.Net.HttpListener
$l.Prefixes.Add("http://localhost:$Port/")
$l.Start()
while ($l.IsListening) {
  $c = $l.GetContext()
  $p = Join-Path $Root ([Uri]::UnescapeDataString($c.Request.Url.AbsolutePath.TrimStart('/')))
  if (Test-Path $p -PathType Leaf) {
    $b = [IO.File]::ReadAllBytes($p); $c.Response.ContentType = 'text/html; charset=utf-8'
    $c.Response.OutputStream.Write($b, 0, $b.Length)
  } else { $c.Response.StatusCode = 404 }
  $c.Response.Close()
}
