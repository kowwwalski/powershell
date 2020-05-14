$ous = Get-ADGroup -filter * -searchbase "OU=%ouname-1%,OU=%ouname-2%,OU=%ouname-n%,DC=%n-lvl-dname%,DC=%2-lvl-dname%,DC=%1-lvl-dname%"

Foreach($Group In $ous) 
    
    {
        $Arrayofmembers = Get-ADGroupMember -Identity $Group -recursive | select name,samaccountname
       
        if ($Arrayofmembers)
        {
            $Group.Name + ":"
        
            foreach ($Member in $Arrayofmembers) 
            {
                $Member.samaccountname + ", " + $Member.name
                #$Member.name
                #$Record."Group Name" = $Group
                #$Record."Name" = $Member.name
                #$Record."UserName" = $Member.samaccountname
            }

            [System.Environment]::NewLine
        }
    }

Read-Host "Press any key"
