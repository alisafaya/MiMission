# -*- coding: utf-8 -*-
# Generated by Django 1.11.8 on 2018-01-12 15:55
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('mimission_app', '0002_delete_language'),
    ]

    operations = [
        migrations.CreateModel(
            name='AuthGroup',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=80, unique=True)),
            ],
            options={
                'managed': False,
                'db_table': 'auth_group',
            },
        ),
        migrations.CreateModel(
            name='AuthGroupPermissions',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
            options={
                'managed': False,
                'db_table': 'auth_group_permissions',
            },
        ),
        migrations.CreateModel(
            name='AuthPermission',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('codename', models.CharField(max_length=100)),
            ],
            options={
                'managed': False,
                'db_table': 'auth_permission',
            },
        ),
        migrations.CreateModel(
            name='AuthUser',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128)),
                ('last_login', models.DateTimeField(blank=True, null=True)),
                ('is_superuser', models.BooleanField()),
                ('username', models.CharField(max_length=150, unique=True)),
                ('first_name', models.CharField(max_length=30)),
                ('last_name', models.CharField(max_length=30)),
                ('email', models.CharField(max_length=254)),
                ('is_staff', models.BooleanField()),
                ('is_active', models.BooleanField()),
                ('date_joined', models.DateTimeField()),
            ],
            options={
                'managed': False,
                'db_table': 'auth_user',
            },
        ),
        migrations.CreateModel(
            name='AuthUserGroups',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
            options={
                'managed': False,
                'db_table': 'auth_user_groups',
            },
        ),
        migrations.CreateModel(
            name='AuthUserUserPermissions',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
            ],
            options={
                'managed': False,
                'db_table': 'auth_user_user_permissions',
            },
        ),
        migrations.CreateModel(
            name='Comment',
            fields=[
                ('commentid', models.AutoField(db_column='commentId', primary_key=True, serialize=False)),
                ('comment', models.CharField(max_length=256)),
                ('date', models.DateTimeField()),
            ],
            options={
                'managed': False,
                'db_table': 'comments',
            },
        ),
        migrations.CreateModel(
            name='DjangoAdminLog',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('action_time', models.DateTimeField()),
                ('object_id', models.TextField(blank=True, null=True)),
                ('object_repr', models.CharField(max_length=200)),
                ('action_flag', models.SmallIntegerField()),
                ('change_message', models.TextField()),
            ],
            options={
                'managed': False,
                'db_table': 'django_admin_log',
            },
        ),
        migrations.CreateModel(
            name='DjangoContentType',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('app_label', models.CharField(max_length=100)),
                ('model', models.CharField(max_length=100)),
            ],
            options={
                'managed': False,
                'db_table': 'django_content_type',
            },
        ),
        migrations.CreateModel(
            name='DjangoMigrations',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('app', models.CharField(max_length=255)),
                ('name', models.CharField(max_length=255)),
                ('applied', models.DateTimeField()),
            ],
            options={
                'managed': False,
                'db_table': 'django_migrations',
            },
        ),
        migrations.CreateModel(
            name='DjangoSession',
            fields=[
                ('session_key', models.CharField(max_length=40, primary_key=True, serialize=False)),
                ('session_data', models.TextField()),
                ('expire_date', models.DateTimeField()),
            ],
            options={
                'managed': False,
                'db_table': 'django_session',
            },
        ),
        migrations.CreateModel(
            name='Follow',
            fields=[
                ('followid', models.AutoField(db_column='followId', primary_key=True, serialize=False)),
            ],
            options={
                'managed': False,
                'db_table': 'follows',
            },
        ),
        migrations.CreateModel(
            name='Language',
            fields=[
                ('languageid', models.AutoField(db_column='languageId', primary_key=True, serialize=False)),
                ('language', models.CharField(max_length=32, unique=True)),
            ],
            options={
                'managed': False,
                'db_table': 'language',
            },
        ),
        migrations.CreateModel(
            name='Languagelevel',
            fields=[
                ('languagelevelid', models.AutoField(db_column='languageLevelId', primary_key=True, serialize=False)),
                ('languagelevel', models.CharField(db_column='languageLevel', max_length=32)),
            ],
            options={
                'managed': False,
                'db_table': 'languageLevel',
            },
        ),
        migrations.CreateModel(
            name='Level',
            fields=[
                ('levelid', models.AutoField(db_column='levelId', primary_key=True, serialize=False)),
                ('level', models.IntegerField(unique=True)),
                ('minimumpoints', models.IntegerField(db_column='minimumPoints')),
            ],
            options={
                'managed': False,
                'db_table': 'levels',
            },
        ),
        migrations.CreateModel(
            name='Mission',
            fields=[
                ('missionid', models.AutoField(db_column='missionId', primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=64, unique=True)),
                ('details', models.TextField()),
                ('duration', models.IntegerField()),
                ('points', models.IntegerField()),
                ('type', models.CharField(max_length=1)),
                ('kickoff', models.DateTimeField()),
                ('cost', models.IntegerField()),
            ],
            options={
                'managed': False,
                'db_table': 'missions',
            },
        ),
        migrations.CreateModel(
            name='Missiontag',
            fields=[
                ('missiontagid', models.AutoField(db_column='missionTagId', primary_key=True, serialize=False)),
            ],
            options={
                'managed': False,
                'db_table': 'missionTag',
            },
        ),
        migrations.CreateModel(
            name='Notification',
            fields=[
                ('notificationid', models.IntegerField(db_column='notificationId', primary_key=True, serialize=False)),
                ('content', models.TextField()),
                ('date', models.DateTimeField()),
            ],
            options={
                'managed': False,
                'db_table': 'notifications',
            },
        ),
        migrations.CreateModel(
            name='Rank',
            fields=[
                ('rankid', models.AutoField(db_column='rankId', primary_key=True, serialize=False)),
                ('rank', models.CharField(max_length=64)),
                ('rankcolor', models.IntegerField(db_column='rankColor')),
            ],
            options={
                'managed': False,
                'db_table': 'ranks',
            },
        ),
        migrations.CreateModel(
            name='Sporttype',
            fields=[
                ('sporttypeid', models.AutoField(db_column='sportTypeId', primary_key=True, serialize=False)),
                ('sporttype', models.CharField(db_column='sportType', max_length=64, unique=True)),
            ],
            options={
                'managed': False,
                'db_table': 'sportTypes',
            },
        ),
        migrations.CreateModel(
            name='Subject',
            fields=[
                ('subjectid', models.AutoField(db_column='subjectId', primary_key=True, serialize=False)),
                ('subject', models.CharField(max_length=64, unique=True)),
            ],
            options={
                'managed': False,
                'db_table': 'subjects',
            },
        ),
        migrations.CreateModel(
            name='Tag',
            fields=[
                ('tagid', models.AutoField(db_column='tagId', primary_key=True, serialize=False)),
                ('tag', models.CharField(max_length=16, unique=True)),
            ],
            options={
                'managed': False,
                'db_table': 'tags',
            },
        ),
        migrations.CreateModel(
            name='Usermission',
            fields=[
                ('usermissionid', models.AutoField(db_column='userMissionId', primary_key=True, serialize=False)),
                ('joiningdate', models.DateTimeField(db_column='joiningDate')),
                ('completed', models.BooleanField()),
            ],
            options={
                'managed': False,
                'db_table': 'userMission',
            },
        ),
        migrations.CreateModel(
            name='Usertag',
            fields=[
                ('usertagid', models.AutoField(db_column='userTagId', primary_key=True, serialize=False)),
            ],
            options={
                'managed': False,
                'db_table': 'userTag',
            },
        ),
        migrations.CreateModel(
            name='Vote',
            fields=[
                ('voteid', models.AutoField(db_column='voteId', primary_key=True, serialize=False)),
                ('vote', models.IntegerField()),
            ],
            options={
                'managed': False,
                'db_table': 'votes',
            },
        ),
        migrations.CreateModel(
            name='Bookmission',
            fields=[
                ('id', models.ForeignKey(db_column='id', on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='mimission_app.Mission')),
                ('bookname', models.CharField(db_column='bookName', max_length=64)),
                ('pageamount', models.IntegerField(blank=True, db_column='pageAmount', null=True)),
            ],
            options={
                'managed': False,
                'db_table': 'bookMissions',
            },
        ),
        migrations.CreateModel(
            name='Languagemission',
            fields=[
                ('id', models.ForeignKey(db_column='id', on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='mimission_app.Mission')),
                ('vocabularyamount', models.IntegerField(db_column='vocabularyAmount')),
            ],
            options={
                'managed': False,
                'db_table': 'languageMissions',
            },
        ),
        migrations.CreateModel(
            name='Scientificmission',
            fields=[
                ('id', models.ForeignKey(db_column='id', on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='mimission_app.Mission')),
                ('scientificpaperno', models.IntegerField(blank=True, db_column='scientificPaperNo', null=True)),
            ],
            options={
                'managed': False,
                'db_table': 'scientificMissions',
            },
        ),
        migrations.CreateModel(
            name='Sportmission',
            fields=[
                ('id', models.ForeignKey(db_column='id', on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='mimission_app.Mission')),
                ('calories', models.IntegerField()),
                ('progresstime', models.IntegerField(blank=True, db_column='progressTime', null=True)),
            ],
            options={
                'managed': False,
                'db_table': 'sportMissions',
            },
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('userid', models.ForeignKey(db_column='userId', on_delete=django.db.models.deletion.CASCADE, primary_key=True, serialize=False, to='mimission_app.AuthUser')),
                ('birthdate', models.DateField()),
                ('autobiyography', models.TextField(blank=True, null=True)),
                ('profileimage', models.TextField(blank=True, db_column='profileImage', null=True)),
                ('points', models.IntegerField()),
            ],
            options={
                'managed': False,
                'db_table': 'users',
            },
        ),
    ]
