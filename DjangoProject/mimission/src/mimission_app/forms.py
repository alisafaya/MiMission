from django import forms



class MissionCreateForm(forms.Form):
	mission_name = forms.CharField(max_length=128)
	mission_details = forms.CharField()
	mission_kickoff = forms.DateTimeField()