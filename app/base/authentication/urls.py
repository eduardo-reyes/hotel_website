from django.urls import path
from . import views

urlpatterns = [
    path('', views.homepage, name="home"),
    path('signup', views.signup, name="signup"),
    path('login', views.login_view, name="login"),
    path('main_user_dashboard', views.main_user_dashboard, name="main_user_dashboard"),
    path('signout', views.signout, name="signout")
]

