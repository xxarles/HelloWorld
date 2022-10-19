FROM public.ecr.aws/lambda/python:3.9


COPY app/req.txt  .
RUN  pip3 install -r req.txt --target "${LAMBDA_TASK_ROOT}"

COPY app/ ${LAMBDA_TASK_ROOT}


# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "main.lambda_handler" ]