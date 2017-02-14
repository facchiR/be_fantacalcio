<?php
namespace Models\Sport;

use Models\Table as Table;

class Atleta extends Table {
    
    // Nome della tabella
    const TABLE_NAME = "atleti";
    const BINDINGS = [
        //"nome_colonna"=>"nome_parametro",
        "id"=>"id",
        "nome"=>"nome",
        "datanascita"=>"datanascita",
        "sesso"=>"sesso"
    ];
    
    public $nome;
    public $datanascita;
    public $sesso;
    public $telefono;
    public $cf;
    protected $iscrizioni = array(); // array of ID
    
    public function __construct($id = 0, $params = []){
        
        parent::init($this, $id);
        
        foreach($params as $k => $v){
            if(is_array($v)){
                $this->$k = 
                        array_map(function($i){return is_int($i)?$i:$i->id;}, $v);
                $this->$k = array_unique($this->$k);
                sort($this->$k);
            }else{
                $this->$k = $v;
            }       
        }
    }
    
    protected function load($id){
        parent::load($id, $this);
        $this->loadIscrizioni();
    }
    
    public function save(){
        parent::save();
        $this->storeIscrizioni();
    }
    
    public function loadIscrizioni(){
        try{
            $sql = "SELECT id FROM iscrizioni WHERE ".self::TABLE_NAME."_id = :id ORDER BY id";
            $stmt = self::$db->prepare($sql);
            if($stmt->execute([":id"=>$this->id])){
                $this->iscrizioni = array_map(function($i){return $i['id'];}, $stmt->fetchAll());
            }
        }catch(\PDOException $e){
            die($e->getMessage());
        }
    }
    
    public function storeIscrizioni(){
        try{
            // rimuovo quelle relazioni che non valgono piu
            $sql = "UPDATE iscrizioni SET atleti_id = null WHERE id NOT IN (".
                    join(", ",$this->iscrizioni).") AND atleti_id = :id";
            $stmt = self::$db->prepare($sql);
            $stmt->execute([":id"=>$this->id]);
        }catch(\PDOException $e){
            die($e->getMessage());
        }
        
        if(count($this->iscrizioni)){
            try{
                // aggiungo quelle relazione che valgono da adesso
                $sql = "UPDATE iscrizioni SET atleti_id = :id WHERE id IN (".
                        join(", ",$this->iscrizioni).")";
                $stmt = self::$db->prepare($sql);
                $stmt->execute([":id"=>$this->id]);
            }catch(\PDOException $e){
                die($e->getMessage());
            }
        }
        
    }
}
