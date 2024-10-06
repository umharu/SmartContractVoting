
# Sistema de votacion 

En este proyecto se encuentra un sistema de votacion en Solidity. El mismo es el primer
proyecto que creamos con mi grupo en el curso que dicta la Universidad del Cema junto con ETH KIPU 

Funcionamiento 
Este smart contract tiene un Owner que es el encargado de agregar wallets para que las mismas puedan emitir votos. A continuacion se realiza una propuesta y luego se emite el voto.
El sistema arroja un evento con un error si la persona vota luego de la fecha de expiracion y ademas valida que el votante no pueda votar dos veces la misma propuesta

Las tecnologias que empleamos fue en su totalidad Solidity.