/***
* @author Chris Aldridge (http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/)
* @date 18/10/2018
* @description Interface du service de gestion des Trigger
*/
public interface ITriggerHandler {
    /***
    * @signature void BeforeInsert(List<SObject> newItems);
    * @description Application d'un traitement spécifique avant insertion de nouveaux enregistrements (de type sObject)
    * @param newItems Liste des nouvelles versions des enregistrements (de type sObject) à insérer
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void BeforeInsert(List<SObject> newItems);

    /***
    * @signature void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
    * @description Application d'un traitement spécifique avant mise à jour d'enregistrements (de type sObject)
    * @param newItems Map des nouvelles versions des enregistrements (de type sObject) à mettre à jour
    * @param oldItems Map des anciennes versions des enregistrements (de type sObject) à mettre à jour
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    /***
    * @signature void BeforeDelete(Map<Id, SObject> oldItems);
    * @description Application d'un traitement spécifique avant suppression d'enregistrements (de type sObject)
    * @param oldItems Map des anciennes versions des enregistrements (de type sObject) à supprimer
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void BeforeDelete(Map<Id, SObject> oldItems);

    /***
    * @signature void AfterInsert(Map<Id, SObject> newItems);
    * @description Application d'un traitement spécifique après insertion d'enregistrements (de type sObject)
    * @param newItems Map des nouvelles versions des enregistrements (de type sObject) après insertion
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void AfterInsert(Map<Id, SObject> newItems);

    /***
    * @signature void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
    * @description Application d'un traitement spécifique après mise à jour d'enregistrements (de type sObject)
    * @param newItems Map des nouvelles versions des enregistrements (de type sObject) après mise à jour
    * @param oldItems Map des anciennes versions des enregistrements (de type sObject) avant mise à jour
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    /***
    * @signature void AfterDelete(Map<Id, SObject> oldItems);
    * @description Application d'un traitement spécifique après suppression d'enregistrements (de type sObject)
    * @param oldItems Map des anciennes versions des enregistrements (de type sObject) supprimés
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void AfterDelete(Map<Id, SObject> oldItems);

    /***
    * @signature void AfterUndelete(Map<Id, SObject> oldItems);
    * @description Application d'un traitement spécifique après restauration d'enregistrements (de type sObject)
    * @param oldItems Map des anciennes versions des enregistrements (de type sObject) aprés restauration
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    void AfterUndelete(Map<Id, SObject> oldItems);

    /***
    * @signature Boolean IsDisabled();
    * @description Indique si les Triggers sont désactivés
    * @param none
    * @return true si les Trigger sont désactivés, false sinon
    * @Exception Dépend de la classe d'implémentation
    */
    Boolean IsDisabled();

    /***
    * @signature String getTriggerName();
    * @description Indique le nom du Trigger
    * @param none
    * @return le nom du Trigger associé
    * @Exception Dépend de la classe d'implémentation
    */
    String getTriggerName();
}