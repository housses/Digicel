/***
* @author Chris Aldridge (http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/)
* @date 18/10/2018
* @description Dispatcher du service de gestion des Trigger
*/
public class TriggerDispatcher {
    /***
    * @signature public static void Run(ITriggerHandler handler);
    * @description Appelez cette méthode à partir de votre Trigger, en passant une instance d'un gestionnaire de Trigger qui implémente ITriggerHandler.
    * Cette méthode déclenchera les méthodes appropriées sur le gestionnaire en fonction du contexte du déclencheur.
    * @param handler Instance d'un gestionnaire de Trigger
    * @return Rien
    * @Exception Dépend de la classe d'implémentation
    */
    public static void Run(ITriggerHandler handler) {

        List<SObject> triggerNew = trigger.new;
        Map<Id, SObject> triggerNewMap = trigger.newMap;
        // Vérification: Le Trigger est-il désactivé? Si il l'est, on sort de la méthode.
        if (handler.IsDisabled()) { return; }

        // Logique du Trigger AVANT opération
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) { // Application d'un traitement spécifique AVANT INSERTION de nouveaux enregistrements (de type sObject)
                handler.BeforeInsert(triggerNew);
            }
            else if (Trigger.IsUpdate) { // Application d'un traitement spécifique AVANT MISE À JOUR d'enregistrements (de type sObject)
                handler.BeforeUpdate(triggerNewMap, trigger.oldMap);
            }
            else if (Trigger.IsDelete) { // Application d'un traitement spécifique AVANT SUPPRESSION d'enregistrements (de type sObject)
                handler.BeforeDelete(trigger.oldMap);
            }
        }

        // Logique du Trigger APRES opération
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert) { // Application d'un traitement spécifique APRÈS INSERTION d'enregistrements (de type sObject)
                handler.AfterInsert(Trigger.newMap);
            }
            else if (Trigger.IsUpdate) { // Application d'un traitement spécifique APRÈS MISE À JOUR d'enregistrements (de type sObject)
                handler.AfterUpdate(trigger.newMap, trigger.oldMap);
            }
            else if (trigger.IsDelete) { // Application d'un traitement spécifique APRÈS SUPPRESSION d'enregistrements (de type sObject)
                handler.AfterDelete(trigger.oldMap);
            }
            else if (trigger.isUndelete) { // Application d'un traitement spécifique APRÈS RESTAURATION d'enregistrements (de type sObject)
                handler.AfterUndelete(trigger.newMap);
            }
        }
    }
}