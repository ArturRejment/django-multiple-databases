class MasterReplicaRouter:

    def db_for_read(self, model, **hints):
        """
        Reads go to a read-only replica
        """
        return 'slave'

    def db_for_write(self, model, **hints):
        """
        Writes always go to primary
        """
        return 'master'

    def allow_relation(self, obj1, obj2, **hints):
        """
        Relations between objects are allowed if both objects are
        in the master/slave pool.
        """
        db_set = {'master', 'slave'}
        if obj1._state.db in db_set and obj2._state.db in db_set:
            return True
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        """
        All non-auth models end up in this pool.
        """
        return True