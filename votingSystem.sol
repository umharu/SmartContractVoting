// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;


contract Voting {


    uint256 public immutable deadLine;
    address private immutable addressOwner;


    constructor(uint256 _deadLine){
        addressOwner = msg.sender;
        deadLine = _deadLine;
    }



    address[] public voter;
    uint256 public counter;

    

    // Estructura de propuesta
    struct Proposal {
        string proposal;
        uint256 neededVotes;
        uint256 votes;
        uint256 coolDown;
    }

    

    // EVENTOS: 

    // Evento cuando un votante vota
    event ProposalVoted(uint256 _index, address _voter);

    // Evento cuando el owner actualiza a los votantes 
    event userAdded(address[] indexed  _users);

    // Evento de Propuesta creada
    event ProposalCreated(uint256 indexed proposalId, string proposal);






    event ProposalApproved(string _message); // <-- Charlarlo con los chicos.
    event ProposalNotApproved(string _message); // <-- 




    error ProposalEmpty();  // Error al intentar agregar una propuesta con el empty vacio
    error ErrorNotOwner();  // Error, no es el owner
    error AlreadyVoted();   // Error si ya ha votado en la propuesta
    error ErrorNotAuthorizedVoter(); // Error si el que llama a la funcion voto no esta dentro de la lista.
    error ErrorProposalRange(); // Error para controlar la funcion de "finishProposal"
    error ProposalExpired(); // Error si la propuesta ya expiro

    // FALTA IMPLEMENTAR
    error ProposalNotExists(); // Error si la propuesta no existe 




    // Funcion para agregar votantes. Solo el owner tiene permiso.
    function addVoter(address[] memory _voter) external {
        //Si el owner que esta en la linea 12 es = a quien quiere agregar la list de votantes entonces se agrega sino revert
        if(addressOwner != msg.sender) revert ErrorNotOwner();
            voter = _voter;
            emit userAdded(_voter);
   }





    // Mapping que almacena propuestas
    mapping( uint256 _proposalId => Proposal _proposal ) public ProposalIdProposal;



    // Funcion para crear propuestas 
    function createProposal(string memory _proposal) external {

        if(bytes32(abi.encode(_proposal)) == bytes32(0)) revert ProposalEmpty();   
        counter++;   
        ProposalIdProposal[counter] = Proposal({
            proposal: _proposal,
            neededVotes: (voter.length / 2) + 1,
            votes: 0,
            coolDown: block.timestamp + deadLine
        });

        emit ProposalCreated(counter, _proposal);  
    }


    // Modificador que controlara si un votante tiene permisos
    modifier onlyVoter() {
        bool isVoter = false;
        for(uint256 i = 0; i < voter.length; ++i) {
            if(voter[i] == msg.sender){
                isVoter = true;
                break;
            }
        }
        
        if(isVoter == false) revert ErrorNotAuthorizedVoter();
        _;  // <-- Breakpoint
    }






    // Mapping para almacenar si un votante ha votado en una propuesta específica
    mapping(uint256 => mapping(address => bool)) public hasVoted;



    // Función para votar en una propuesta
    function voteProposal(uint256 _proposalId) external onlyVoter {
        // Comprobamos si la propuesta no expiró
        require( block.timestamp < ProposalIdProposal[_proposalId].coolDown, "ProposalExpired") ;
        // Verificar si el votante ya ha votado en la propuesta
        require(!hasVoted[_proposalId][msg.sender] == true, "AlreadyVoted" );

        // Marcar que el votante ha votado
        hasVoted[_proposalId][msg.sender] = true;
        // Incrementar el contador de votos
        ProposalIdProposal[_proposalId].votes += 1;

        emit ProposalVoted( _proposalId, msg.sender);
        
    }




    function finishProposals(uint256 _startIndex, uint256 _lastIndex) external {
        if (_startIndex > _lastIndex || _lastIndex > counter ){
            revert ErrorProposalRange();
        }

        for(uint256 i = _startIndex; i <= _lastIndex; i++){
            
            if (ProposalIdProposal[i].votes >= ProposalIdProposal[i].neededVotes) {
                // Concatenación correcta de strings usando abi.encodePacked
                emit ProposalApproved(string(abi.encodePacked("Se aprobo la propuesta: ", ProposalIdProposal[i].proposal)));
            } else {
                emit ProposalNotApproved(string(abi.encodePacked("No se aprobo la propuesta: ", ProposalIdProposal[i].proposal)));
            }

        }
    }








    
    function getCoolDown() external view returns (uint256) {
        return block.timestamp + deadLine;
    }


    // Funcion para mostrar la propueesta usando su indice
    function getProposal(uint256 _proposalId) external view returns (Proposal memory) {
        return ProposalIdProposal[_proposalId];
    }


    // Funcion para ver quien es el owner
    function getOwner() public view returns (address) {
        return addressOwner;
    }


    // Funcion para ver la cantidad de la variable "counter"
    function getCounter() public view returns (uint256) {
        return counter;
    }


    // Funcion para ver las address autorizadas para votar
    function getAddress() public view returns (address[] memory) {
        return voter;
    }


}