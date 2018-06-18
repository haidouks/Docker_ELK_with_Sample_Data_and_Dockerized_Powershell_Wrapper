$uri = "http://elasticsearch:9200" 
function Invoke-ES ($verb, $params, $body)  {
    Write-Verbose -Message "`nCalling [$uri/$params]"
    if($body) {
        if($body) {
            Write-Verbose -Message "BODY`n--------------------------------------------`n$body`n--------------------------------------------`n"
        }
    }
    $response = Invoke-RestMethod -Uri "$uri/$params" -method $verb -Headers $headers -ContentType 'application/json' -Body $body
    return $response.Content
}

function Get-ESData($params) {
    Invoke-ES -verb "Get" -params $params
}

function Delete-ESData($params) {
    Invoke-ES -verb "Delete" -params $params

}

function Add-ESData($index, $type, $json, $obj) {
    
    if($obj) {
        $json = ConvertTo-Json -Depth 10 $obj
    }
    Invoke-ES -verb "Post" -params "$index/$type" -body $json
}

function New-ESIndex ($index, $json, $obj) {
    if($obj) {
        $json = ConvertTo-Json -Depth 10 $obj
    }
    Invoke-ES -verb Put -params $index -body $json
}

New-ESIndex -index "myfirstindex" -obj @{
    mappings = @{
        entry = @{
            properties = @{
                Value = @{
                    type = "text"
                }
                DisplayHint = @{
                    type = "text"
                }
                DateTime = @{
                    type = "date"                  
                }
            }
        }
    }
}

Add-ESData -index "myfirstindex" -type 'entry' -obj @{
    Value = "$(get-date)"
    DisplayHint = "2"
    DateTime = [DateTime]::Now.ToUniversalTime().ToString("o")
}