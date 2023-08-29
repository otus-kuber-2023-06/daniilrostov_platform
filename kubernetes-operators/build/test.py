import kopf
import yaml
import kubernetes
import time
from jinja2 import Environment, FileSystemLoader

def wait_until_job_end(jobname):
    api = kubernetes.client.BatchV1Api()
    job_finished = False
    jobs = api.list_namespaced_job('default')
    while (not job_finished) and \
            any(job.metadata.name == jobname for job in jobs.items):
        time.sleep(1)
        jobs = api.list_namespaced_job('default')
        for job in jobs.items:
            if job.metadata.name == jobname:
                print(f"job with { jobname }  found,wait untill end")
                if job.status.succeeded == 1:
                    print(f"job with { jobname }  success")
                    job_finished = True

def render_template(filename, vars_dict):
    env = Environment(loader=FileSystemLoader('./templates'))
    template = env.get_template(filename)
    yaml_manifest = template.render(vars_dict)
    json_manifest = yaml.load(yaml_manifest)
    return json_manifest


# Генерируем JSON манифесты для деплоя
# persistent_volume = render_template('mysql-pv.yml.j2',
#                                     {'name': name,
#                                         'storage_size': storage_size})
# persistent_volume_claim = render_template('mysql-pvc.yml.j2',
#                                             {'name': name,
#                                             'storage_size': storage_size})
# service = render_template('mysql-service.yml.j2', {'name': name})

deployment = render_template('mysql-deployment.yml.j2', {
    'name': name,
    'image': image,
    'password': password,
    'database': database})
# restore_job = render_template('restore-job.yml.j2', {
#     'name': name,
#     'image': image,
#     'password': password,
#     'database': database})

new_var = deployment
print(new_var)