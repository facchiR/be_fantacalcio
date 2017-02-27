<?php
namespace Models\Sport;

use Models\Table as Table;

class Calciatore extends Table {
    
    // Nome della tabella
    const TABLE_NAME = "calciatore";
    const BINDINGS = [
        //"nome_colonna"=>"nome_parametro",
        "id"=>"id",
        "nome"=>"nome",
        "ruolo"=>"ruolo",
        "squadra_id"=>"squadra_id",
        
    ];
    
    public $nome;
    public $ruolo;
    public $squadra_id = null;
    
        
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
        $this->loadSquadra();
    }
    
    public function save(){
        parent::save();
        //$this->storeSquadra();
    }
    
     public function loadSquadra() {
        try {
            $sql = "SELECT id FROM squadra WHERE id = :id ORDER BY id";
            $stmt = self::$db->prepare($sql);
            if ($stmt->execute([":id" => $this->id])) {
                // $this->cat = $this->id; 
                $squadra_id = $stmt->fetch();
            }
        } catch (\PDOException $e) {
            die($e->getMessage());
        }
    }
    
    
    public function storeSquadra(){
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
