from __future__ import unicode_literals

from django.db import models

# Create your models here.
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=80)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    email = models.CharField(max_length=254)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Rank(models.Model):
    rankid = models.AutoField(db_column='rankId', primary_key=True)  # Field name made lowercase.
    rank = models.CharField(max_length=64)
    rankcolor = models.IntegerField(db_column='rankColor')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'ranks'

    def __str__(self):
        return self.rank

class Subject(models.Model):
    subjectid = models.AutoField(db_column='subjectId', primary_key=True)  # Field name made lowercase.
    subject = models.CharField(unique=True, max_length=64)

    class Meta:
        managed = False
        db_table = 'subjects'

    def __str__(self):
        return self.subject

class Language(models.Model):
    languageid = models.AutoField(db_column='languageId', primary_key=True)  # Field name made lowercase.
    language = models.CharField(unique=True, max_length=32)

    class Meta:
        managed = False
        db_table = 'language'

    def __str__(self):
        return self.language

class Languagelevel(models.Model):
    languagelevelid = models.AutoField(db_column='languageLevelId', primary_key=True)  # Field name made lowercase.
    languagelevel = models.CharField(db_column='languageLevel', max_length=32)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'languageLevel'

    def __str__(self):
        return self.languagelevel

class Tag(models.Model):
    tagid = models.AutoField(db_column='tagId', primary_key=True)  # Field name made lowercase.
    tag = models.CharField(unique=True, max_length=16)

    class Meta:
        managed = False
        db_table = 'tags'

    def __str__(self):
        return self.tag

class Level(models.Model):
    levelid = models.AutoField(db_column='levelId', primary_key=True)  # Field name made lowercase.
    level = models.IntegerField(unique=True)
    rank = models.ForeignKey('Rank', models.DO_NOTHING, db_column='rank')
    minimumpoints = models.IntegerField(db_column='minimumPoints')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'levels'

    def __str__(self):
        return self.level


class User(models.Model):
    userid = models.OneToOneField(AuthUser,on_delete= models.CASCADE, db_column='userId', primary_key=True)  # Field name made lowercase.
    birthdate = models.DateField()
    autobiyography = models.TextField(blank=True, null=True)
    profileimage = models.TextField(db_column='profileImage', blank=True, null=True)  # Field name made lowercase.
    level = models.ForeignKey('Level', models.DO_NOTHING, db_column='level')
    points = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'users'

    def __str__(self):
        return "%s %s" (self.userid.first_name,self.userid.last_name)

class Sporttype(models.Model):
    sporttypeid = models.AutoField(db_column='sportTypeId', primary_key=True)  # Field name made lowercase.
    sporttype = models.CharField(db_column='sportType', unique=True, max_length=64)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'sportTypes'

    def __str__(self):
        return self.sporttype


class Mission(models.Model):
    missionid = models.AutoField(db_column='missionId', primary_key=True)  # Field name made lowercase.
    name = models.CharField(unique=True, max_length=64)
    details = models.TextField()
    duration = models.IntegerField()
    points = models.IntegerField()
    type = models.CharField(max_length=1)
    kickoff = models.DateTimeField()
    suggestor = models.ForeignKey('User', models.DO_NOTHING, db_column='suggestor')
    cost = models.IntegerField()

    def __str__(self):
        return self.name

    class Meta:
        managed = False
        db_table = 'missions'

class Bookmission(models.Model):
    mission = models.OneToOneField('mission',on_delete = models.CASCADE, db_column='id', primary_key=True)
    bookname = models.CharField(db_column='bookName', max_length=64)  # Field name made lowercase.
    language = models.ForeignKey('Language', models.SET_NULL, db_column='language', blank=True, null=True)
    subject = models.ForeignKey('Subject', models.SET_NULL, db_column='subject', blank=True, null=True)
    pageamount = models.IntegerField(db_column='pageAmount', blank=True, null=True)  # Field name made lowercase.

    def __str__(self):
        return self.mission.name

    class Meta:
        managed = False
        db_table = 'bookMissions'



class Comment(models.Model):
    commentid = models.AutoField(db_column='commentId', primary_key=True)  # Field name made lowercase.
    comment = models.CharField(max_length=256)
    user = models.ForeignKey('User', models.CASCADE, db_column='user')
    mission = models.ForeignKey('Mission', models.CASCADE, db_column='mission')
    date = models.DateTimeField()

    def __str__(self):
        return self.comment

    class Meta:
        managed = False
        db_table = 'comments'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Follow(models.Model):
    followid = models.AutoField(db_column='followId', primary_key=True)  # Field name made lowercase.
    followed = models.ForeignKey('User', models.CASCADE, db_column='followed', related_name='followed_user')
    follower = models.ForeignKey('User', models.CASCADE, db_column='follower', related_name='follower_user')

    class Meta:
        managed = False
        db_table = 'follows'


class Languagemission(models.Model):
    mission = models.OneToOneField('mission',on_delete = models.CASCADE, db_column='id', primary_key=True)
    vocabularyamount = models.IntegerField(db_column='vocabularyAmount')  # Field name made lowercase.
    language = models.ForeignKey(Language, models.SET_NULL, db_column='language', blank=True, null=True)
    languagelevel = models.ForeignKey(Languagelevel, models.SET_NULL, db_column='languageLevel', blank=True, null=True)  # Field name made lowercase.

    def __str__(self):
        return self.mission.name

    class Meta:
        managed = False
        db_table = 'languageMissions'


class Missiontag(models.Model):
    missiontagid = models.AutoField(db_column='missionTagId', primary_key=True)  # Field name made lowercase.
    tag = models.ForeignKey('Tag', models.CASCADE, db_column='tag')
    mission = models.ForeignKey('Mission', models.CASCADE, db_column='mission')

    class Meta:
        managed = False
        db_table = 'missionTag'


class Notification(models.Model):
    notificationid = models.IntegerField(db_column='notificationId', primary_key=True)  # Field name made lowercase.
    notificateduser = models.ForeignKey('User', models.CASCADE, db_column='notificatedUser', related_name='notificated_user')  # Field name made lowercase.
    fromuser = models.ForeignKey('User', models.CASCADE, db_column='fromUser', related_name='from_user')  # Field name made lowercase.
    content = models.TextField()
    date = models.DateTimeField()
    aboutmission = models.ForeignKey(Mission, models.CASCADE, db_column='aboutMission', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'notifications'

    def __str__(self):
        return self.content


class Scientificmission(models.Model):
    mission = models.OneToOneField('mission',on_delete = models.CASCADE, db_column='id', primary_key=True)
    subject = models.ForeignKey('Subject', models.SET_NULL, db_column='subject', blank=True, null=True)
    scientificpaperno = models.IntegerField(db_column='scientificPaperNo', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'scientificMissions'

    def __str__(self):
        return self.mission.name


class Sportmission(models.Model):
    mission = models.OneToOneField('mission',on_delete = models.CASCADE, db_column='id', primary_key=True)
    calories = models.IntegerField()
    progresstime = models.IntegerField(db_column='progressTime', blank=True, null=True)  # Field name made lowercase.
    type = models.ForeignKey('Sporttype', models.SET_NULL, db_column='type', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sportMissions'

    def __str__(self):
        return self.mission.name


class Usermission(models.Model):
    usermissionid = models.AutoField(db_column='userMissionId', primary_key=True)  # Field name made lowercase.
    user = models.ForeignKey('User', models.CASCADE, db_column='user')
    mission = models.ForeignKey(Mission, models.CASCADE, db_column='mission')
    joiningdate = models.DateTimeField(db_column='joiningDate')  # Field name made lowercase.
    completed = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'userMission'

class Usertag(models.Model):
    usertagid = models.AutoField(db_column='userTagId', primary_key=True)  # Field name made lowercase.
    user = models.ForeignKey('User', models.CASCADE, db_column='user')
    tag = models.ForeignKey(Tag, models.CASCADE, db_column='tag')

    class Meta:
        managed = False
        db_table = 'userTag'


class Vote(models.Model):
    voteid = models.AutoField(db_column='voteId', primary_key=True)  # Field name made lowercase.
    vote = models.IntegerField()
    user = models.ForeignKey(User, models.CASCADE, db_column='user')
    mission = models.ForeignKey(Mission, models.CASCADE, db_column='mission')

    class Meta:
        managed = False
        db_table = 'votes'
        unique_together = (('user', 'mission'),)

    def __str__(self):
        return "%s voted with %d to %s" (self.user.auth_user.username, self.vote, self.mission.name)