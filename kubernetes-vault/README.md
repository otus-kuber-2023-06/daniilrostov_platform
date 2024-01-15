### DZ-11


```kubectl exec -it vault-0 -- vault operator init --key-shares=1 --key-threshold=1```

res:  
Unseal Key 1: GR5IFYrF1B5UMuzoGpzl9CQPTUZwY8K8mJrUkQzZmgk=  

Initial Root Token: hvs.xFFSCI8RhyTh4JlL77tdtvC3  

```kubectl exec -it vault-0 -- vault status```

NAME: vault    
LAST DEPLOYED: Thu Dec  7 20:13:01 2023  
NAMESPACE: default  
STATUS: deployed  
REVISION: 1  
NOTES:  
Thank you for installing HashiCorp Vault!  
  
Now that you have deployed Vault, you should look over the docs on using  
Vault with Kubernetes available here:  
  
https://developer.hashicorp.com/vault/docs  
  
  
Your release is named vault. To learn more about the release, try:  
  
  $ helm status vault  
  $ helm get manifest vault  
  
  
  
```kubectl exec -it vault-0 -- vault login```   
Token (will be hidden):  
Success! You are now authenticated. The token information displayed below  
is already stored in the token helper. You do NOT need to run "vault login"  
again. Future Vault requests will automatically use this token.  
  
Key                  Value  
---                  -----  
token                hvs.xFFSCI8RhyTh4JlL77tdtvC3  
token_accessor       Bm5vYH79tlEwMhvXfQBUkZpK  
token_duration       ∞  
token_renewable      false  
token_policies       ["root"]  
identity_policies    []  
policies             ["root"]  


```kubectl exec -it vault-0 -- vault auth list```  
Path      Type     Accessor               Description                Version    
----      ----     --------               -----------                -------    
token/    token    auth_token_dc737588    token based credentials    n/a   

```kubectl exec -it vault-0 -- vault read otus/otus-ro/config```  
Key                 Value  
---                 -----  
refresh_interval    768h  
password            asajkjkahs  
username            otus  


##OR  
```kubectl exec -it vault-0 -- vault operator unseal```  

##THEN  
```kubectl exec -it vault-0 -- vault auth list```
Path           Type          Accessor                    Description                Version  
----           ----          --------                    -----------                -------  
kubernetes/    kubernetes    auth_kubernetes_7dd3445b    n/a                        n/a  
token/         token         auth_token_dc737588         token based credentials    n/a  





