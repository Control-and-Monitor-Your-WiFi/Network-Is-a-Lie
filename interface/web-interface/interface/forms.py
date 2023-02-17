from django import forms

class MacForm(forms.Form):
    mac = forms.CharField(
      widget=forms.TextInput(
            attrs={
                "placeholder": "12:FF:42:C2:C2:FF",
                "class": "form-control"
            }
    ))